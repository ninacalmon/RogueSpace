# UNUSED_CODE.md — Dead code & oddities inventory

> Audit of `vox vacui` (Godot 4.5, folder `RogueSpace-main`) performed on 2026‑08‑25.
> "Unused" = **no reference found anywhere** in `.tscn`, `.gd`, or `.godot` files outside `addons/` and `Tests/` (grep for the basename, including `preload`/`load`/`ext_resource`/autoload entries). Line numbers are as of the audit date.

---

## 1. Confirmed unused / dead code

### 1.1 `res://Scenes/Modulars/asteroid-old.gd`
- **Use case:** Older (pre‑refactor) version of the asteroid `RigidBody2D` script (`extends BodySetup`, 122 lines). The current asteroid logic lives in `res://Scenes/Modulars/asteroid.gd` and is attached to `asteroid_small.tscn` / `asteroid_medium.tscn` / `asteroid_big.tscn`.
- **Where it is used:** nowhere. Grep for `asteroid-old` → **0 hits** in any `.gd`/`.tscn`/`.godot`.
- **Part of scenes:** none.
- **Recommendation:** delete; it is a leftover duplicate that can confuse future changes (identical filename prefix).

### 1.2 `res://paths_hub.gd`
- **Use case:** intended as a central registry/hub of resource paths (`extends Node`, only 2 lines, completely empty body). Nothing reads or writes it at runtime.
- **Where it is used:** registered as an autoload singleton **`PathsHub`** at `res://project.godot:29` (`PathsHub="*res://paths_hub.gd"`), but the autoload name is **never referenced anywhere in non‑test code**.
- **Part of scenes:** none.
- **Recommendation:** remove the autoload entry (or implement the hub); as is, it is an empty registry occupying a global singleton slot.


### 1.4 Unused planet/moon body variants (SpaceBodies)

| File | Notes |
|---|---|
| `res://Scenes/SpaceBodies/planet.tscn` | generic base planet, no refs |
| `res://Scenes/SpaceBodies/planet_giant.tscn` | no refs |
| `res://Scenes/SpaceBodies/planet_medium1.tscn` | superseded by `PickedPlanets/planet_medium.tscn` |
| `res://Scenes/SpaceBodies/Moons/Moon1.tscn` | no refs |
| `res://Scenes/SpaceBodies/Moons/Moon3.tscn` | no refs |

---

## 2. Files you flagged that are actually in use

These came up as "possibly unused" but are **genuinely referenced** by live scenes — do **not** delete them, they were only excluded from unit‑test coverage.

| File | Confirmed use |
|---|---|
| `res://ui_sounds.tscn` (script `res://ui_sounds.gd`) | Audio SFX nodes for UI. Referenced by `res://Scenes/Levels/menu.tscn:3` (root ext_resource) and `res://Scenes/Spaceship/Monitor.tscn:17`. |
| `res://Scenes/Levels/rich_text_label.gd` | Flicker/timed text behavior on the menu. Attached in `menu.tscn:9`. |
| `res://Scenes/Levels/rich_text_label_2.gd` | Same — `menu.tscn:10`. |
| `res://Scenes/Levels/rich_text_label_4.gd` | Same — `menu.tscn:8`. |
| `res://Scenes/Levels/rich_text_label_10.gd` | Same — `menu.tscn:13`. |
| `res://input_guide_unit.gd` | Node used by **autoload** `input_guide.tscn` (singleton `InputGuide`, `project.godot:31`). `input_guide.tscn:4` embeds `input_guide_unit.tscn:3` (→ `res://input_guide_unit.gd`). |

---

## 3. Oddities / code smell

### 3.1 `res://stats_manager.gd:55` — malformed typed `const`
- **Code:** `const FUEL_IMPULSE_USE_STEP: = 0.5` (missing type between `:` and `=`, should be `: float = 0.5` or inferred `:=`).
- **Still loads** (the project parses it), but it is inconsistent with every sibling const (`const FUEL_USE_STEP: float = 0.1`).
- **Where it is used (line):** `res://Scenes/Player/player.gd:201` (`StatsManager.player_current_fuel -= StatsManager.FUEL_IMPULSE_USE_STEP`). So the value is live gameplay fuel cost for impulses.
- **Recommendation:** fix to `const FUEL_IMPULSE_USE_STEP: float = 0.5` and re‑verify.

### 3.2 `res://globals.gd:31-35` — setter flips the flag to `false` immediately
```gdscript
var has_energy_in_spaceship: bool = false:
	set (value):
		if value == true:
			fragments_value_to_sum = StatsManager.resources_needed
			has_energy_in_spaceship = false   # <-- self reset
```
- Any writer setting `true` (only site: `res://Scenes/Spaceship/resources_deposit.gd:31`) will **store the current `resources_needed` into `fragments_value_to_sum` and immediately clear the flag**. The property itself can therefore never be read as `true`.
- `fragments_value_to_sum` is then added to the bank by `Globals.add_frag_sum()` at `globals.gd:38` (`StatsManager.current_resources += fragments_value_to_sum` at `:39`).
- **Smell:** mixing "record energy deposit" side‑effect into a plain `bool` property, with a setter that always ends `false` — the `has_energy…` name is misleading. Tests (`Tests/Autoloads/Unit/globals_test.gd`) pin the current behavior.

### 3.3 `res://stats_manager.gd:49` — `player_have_perfurator` defaults `true`
```gdscript
var player_have_perfurator: bool = true
```
- Default `true`, while everything else that grants it (`power_ups.gd:74` in `apply_power_up("Perfurator")`) implies it must be **earned.** Guard site: `res://Scenes/SpaceBodies/vulnerability_area.gd:20` (`if !(body is Player) or !StatsManager.player_have_perfurator:`). Only writer is `power_ups.gd:74`.
- **Smell:** start‑of‑game state grants the power-up; likely should be `false` (reach/ask design).

### 3.4 `res://basic_bullet.gd` lives at project **root**, not in `Scenes/Bullets/`
- The bullet script is at `res://basic_bullet.gd` (not `res://Scenes/Bullets/basic_bullet.gd` — no such file).
- **Attached by** `res://Scenes/Bullets/basic_bullet.tscn:3` and `res://Scenes/Bullets/super_bullet.tscn:3`.
- **Smell:** placement inconsistent with the folder the scenes live in. Tests reference the root path (`Tests/Unit/basic_bullet_test.gd:3`).

### 3.5 `res://Scenes/BackHoles/` vs `res://Scenes/BlackHoles/` (folder typo; both on disk via git)
- Git status shows an **in‑progress rename**: `D Scenes/BackHoles/*` (deleted: `black_hole.gd`, `.uid`, `black_hole.tscn`, `black_hole_shader.gd`, `superm_black_hole.gd`, `supermassive_black_hole.tscn`) and untracked `?? Scenes/BlackHoles/` (new folder, correct spelling).
- All live level scenes now reference the **new** casing `res://Scenes/BlackHoles/…`:
  - `Level_Day1.tscn:25` (`black_hole.tscn`), `:27` (`supermassive_black_hole.tscn`), `:173` node `BlackHoles`
  - same pattern in `Level_Day2.tscn`, `Level_Day3.tscn`, `Tutorial.tscn`.
- **Note for finish:** commit the rename (deleting `BackHoles`) so the repo state matches the live references.

### 3.6 Case‑sensitivity of `res://Scenes/modulars/` (lowercase) inside asteroid scenes
- `asteroid_big.tscn:9`, `asteroid_medium.tscn:9` reference `path="res://Scenes/modulars/gravitational_field.tscn"` — **lowercase `modulars/`**, while the folder on disk is `res://Scenes/Modulars/`.
- This works on the usual Windows editor (case‑insensitive file systems) but **breaks on case‑sensitive systems** (Linux/macOS/CI). Same class of hazard as 3.5.
- **Recommendation:** normalize these paths to `res://Scenes/Modulars/…` exactly.

---

## How this list was produced
- Greps covered `.gd`, `.tscn`, `.godot` under `res://` excluding `addons/` and `Tests/`.
- Scene membership = the attaching `ext_resource ... path=` entries in `.tscn` files.
- No existing game code was modified while producing this report or the test suite.
