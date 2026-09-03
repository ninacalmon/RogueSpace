# UNUSED_CODE.md — Dead code & oddities inventory

> Audit of `vox vacui` (Godot 4.5, folder `RogueSpace-main`) performed on 2026‑08‑25.
> "Unused" = **no reference found anywhere** in `.tscn`, `.gd`, or `.godot` files outside `addons/` and `Tests/` (grep for the basename, including `preload`/`load`/`ext_resource`/autoload entries). Line numbers are as of the audit date.

---

## 1. Confirmed unused / dead code

### 1.1 ~~`res://scenes/modulars/asteroid-old.gd`~~ — **RESOLVED (deleted on disk)**
- **Use case:** Older (pre‑refactor) version of the asteroid `RigidBody2D` script (`extends BodySetup`, 122 lines). The current asteroid logic lives in `res://scenes/asteroids/asteroid_body/asteroid.gd`.
- **Where it is used:** nowhere. Grep for `asteroid-old` → **0 hits** in any `.gd`/`.tscn`/`.godot`.
- **Status:** deleted on disk; no references remain.

### 1.2 ~~`res://paths_hub.gd`~~ — **RESOLVED (deleted on disk)**
- **Use case:** intended as a central registry/hub of resource paths (`extends Node`, only 2 lines, completely empty body). Nothing reads or writes it at runtime.
- **Where it is used:** was registered as an autoload singleton **`PathsHub`** in `project.godot`, but the autoload name was never referenced anywhere in non‑test code.
- **Status:** deleted on disk; the autoload entry has been removed from `project.godot`.


### 1.4 ~~Unused planet/moon body variants (SpaceBodies)~~ — **RESOLVED on disk**

| File | Notes |
|---|---|
| `res://scenes/space_bodies/planet.tscn` | generic base planet, no refs — **deleted on disk** |
| `res://scenes/space_bodies/planet_giant.tscn` | no refs — **deleted on disk** |
| `res://scenes/space_bodies/planet_medium1.tscn` | superseded by `planet_medium.tscn` — **deleted on disk** |
| `res://scenes/space_bodies/moons/Moon1.tscn` | **IN USE** — instanced as Orbit `body_scene` in `planet_medium.tscn:33` |
| `res://scenes/space_bodies/moons/Moon3.tscn` | **IN USE** — instanced as Orbit `body_scene` in `planet_small1.tscn:30` |

---

## 2. Files you flagged that are actually in use

These came up as "possibly unused" but are **genuinely referenced** by live scenes — do **not** delete them, they were only excluded from unit‑test coverage.

| File | Confirmed use |
|---|---|
| `res://scenes/modulars/ui_sounds.tscn` (script `res://scenes/modulars/ui_sounds.gd`) | Audio SFX nodes for UI. Referenced by `res://scenes/levels/menus/menu.tscn:3` (root ext_resource) and `res://scenes/spaceship/Monitor.tscn:17`. |
| `res://scenes/levels/rich_text_label.gd` | Flicker/timed text behavior on the menu. Attached in `menu.tscn:9`. |
| `res://scenes/levels/rich_text_label_2.gd` | Same — `menu.tscn:10`. |
| `res://scenes/levels/rich_text_label_4.gd` | Same — `menu.tscn:8`. |
| `res://scenes/levels/rich_text_label_10.gd` | Same — `menu.tscn:13`. |
| `res://autoloads/input_guide_unit.gd` | Node used by **autoload** `input_guide.tscn` (singleton `InputGuide`, `project.godot:31`). `input_guide.tscn:4` embeds `input_guide_unit.tscn:3` (→ `res://autoloads/input_guide_unit.gd`). |

---

## 3. Oddities / code smell

### 3.1 ~~`res://autoloads/stats_manager.gd:55` — malformed typed `const`~~ — **RESOLVED**
- The malformed `const FUEL_IMPULSE_USE_STEP: = 0.5` was fixed to `const FUEL_IMPULSE_USE_STEP: float = 0.5` in the cleaning pass (Phase 1.5). Value unchanged (`0.5`); the test suite pins the literal `0.5` and still passes (210/210).

### 3.2 `res://autoloads/globals.gd:31-35` — setter flips the flag to `false` immediately
```gdscript
var has_energy_in_spaceship: bool = false:
	set (value):
		if value == true:
			fragments_value_to_sum = StatsManager.resources_needed
			has_energy_in_spaceship = false   # <-- self reset
```
- Any writer setting `true` (only site: `res://scenes/spaceship/resources_deposit.gd:31`) will **store the current `resources_needed` into `fragments_value_to_sum` and immediately clear the flag**. The property itself can therefore never be read as `true`.
- `fragments_value_to_sum` is then added to the bank by `Globals.add_frag_sum()` at `globals.gd:38` (`StatsManager.current_resources += fragments_value_to_sum` at `:39`).
- **Smell:** mixing "record energy deposit" side‑effect into a plain `bool` property, with a setter that always ends `false` — the `has_energy…` name is misleading. Tests (`Tests/Autoloads/Unit/globals_test.gd`) pin the current behavior.

### 3.3 `res://autoloads/stats_manager.gd:49` — `player_have_perfurator` defaults `true`
```gdscript
var player_have_perfurator: bool = true
```
- Default `true`, while everything else that grants it (`power_ups.gd:74` in `apply_power_up("Perfurator")`) implies it must be **earned.** Guard site: `res://scenes/space_bodies/vulnerability_area.gd:20` (`if !(body is Player) or !StatsManager.player_have_perfurator:`). Only writer is `power_ups.gd:74`.
- **Smell:** start‑of‑game state grants the power-up; likely should be `false` (reach/ask design).

### 3.4 ~~`res://basic_bullet.gd` lives at project root~~ — **RESOLVED (moved)**
- The bullet script moved to `res://scenes/bullets/player_bullet.gd` (shared by `basic_bullet.tscn` and `super_bullet.tscn`). The root copy no longer exists.

### 3.5 ~~`BackHoles/` → `BlackHoles/` folder typo~~ — **RESOLVED**
- The on-disk folder is now **`res://scenes/black_hole/`** (lowercase, singular) with `supermassive_black_holes/` below it. All live level scenes (`Level_Day1/2/3.tscn`, `Tutorial.tscn`) and `Tests/Unit/black_hole_test.gd` consistently reference `res://scenes/black_hole/…`. Do **not** rename again.

### 3.6 ~~Case‑sensitivity of `res://scenes/modulars/` (lowercase) inside asteroid scenes~~ — **RESOLVED**
- The folder on disk is `res://scenes/modulars/` (lowercase) and the asteroid scenes reference `path="res://scenes/modulars/gravitational_field.tscn"` — the case matches, so this no longer breaks on case‑sensitive systems (Linux/macOS/CI).

---

## How this list was produced
- Greps covered `.gd`, `.tscn`, `.godot` under `res://` excluding `addons/` and `Tests/`.
- Scene membership = the attaching `ext_resource ... path=` entries in `.tscn` files.
- No existing game code was modified while producing this report or the test suite.
