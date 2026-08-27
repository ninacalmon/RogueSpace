# FILESYSTEM_MISTAKES.md — Filesystem organization audit

> Audit of `vox vacui` (Godot 4.5, folder `RogueSpace-main`) performed on 2026‑08‑25.
> Scope: filesystem structure mistakes only — misplaced files, disorganized folders, and redundant/erroneous/non‑descriptive filenames.
> For every item: where it lives, where it is **referenced** (`file:line`), and what it is used for.
> Companion docs: `UNUSED_CODE.md` (dead code), `UNUSED_RESOURCES.md` (dead assets).

---

## 1. Misplaced files (in the wrong folder)

### 1.1 `res://basic_bullet.gd` — lives at the project root, belongs in `Scenes/Bullets/`
- A bullet projectile script (spawns at `StatsManager.player_current_bullet`), yet it sits at `res://` root alongside the autoload scripts.
- **Referenced by:** `Scenes/Bullets/basic_bullet.tscn:3`, `Scenes/Bullets/super_bullet.tscn:3` (both attach `path="res://basic_bullet.gd"`), `Tests/Unit/basic_bullet_test.gd:3`.
- **Use:** player bullet movement/collision (`_process`, `_on_body_entered`). Both bullet scenes resolve to this one root script.
- **Recommendation:** move to `Scenes/Bullets/` and re-point the two `path=` lines (+ test const + `.uid`).
INSTRUCTION: move file and re-point its references.

### 1.2 `input_guide.gd` / `input_guide.tscn` / `input_guide_unit.gd` / `input_guide_unit.tscn` — key-hint UI at root
- The InputGuide autoload scene chain lives at `res://` root, while its controller logic is **duplicated in two other folders**.
- **Referenced by:** autoload `InputGuide="*res://input_guide.tscn"` (`project.godot:31`); consumed by `Scenes/Levels/Level_Day1.tscn`, `Level_Day2.tscn`, `Level_Day3.tscn`, `Scenes/Levels/spaceship_interior.tscn`, `Tutorial.tscn`. `input_guide.tscn:4` instantiates `input_guide_unit.tscn`; `input_guide_unit.tscn:3` → `input_guide_unit.gd`.
- **Two divergent admin variants (split):** `Scenes/Levels/input_guide_admin.gd` (used by `Level_Day1.tscn:30`, `Level_Day2.tscn:30`, `Level_Day3.tscn:31`, `Tutorial.tscn:31`) and a **separate** `Scenes/Spaceship/input_guide_admin.gd` (used by `spaceship_interior.tscn:26`). Same subsystem, base at root, admin logic duplicated across `Levels/` and `Spaceship/`.
- **Use:** on-screen key hints driven by the input map.
- **Recommendation:** consolidate admin variants; move unit/admin/control into a single dedicated folder (e.g. `Scenes/UI/InputGuide/`).
INSTRUCTION: ignore.

### 1.3 `res://ui_sounds.gd` + `res://ui_sounds.tscn` — UI audio system at root
- Script + scene for UI click/hover sounds are at `res://` root, outside every audio/UI folder.
- **Referenced by:** `Scenes/Levels/menu.tscn` (ext_resource) and `Scenes/Spaceship/Monitor.tscn:17`.
- **Use:** hover/click SFX on UI elements.
- **Recommendation:** move to `Scenes/UI/` (or under `Sound Effects/`) and re-point references.
INSTRUCTION: ignore.

### 1.4 `scenes/start_limbo.gd` + `scenes/start_limbo.tscn` — the MAIN scene buried at `Scenes/` depth
- The boot/loading scene sits directly under `Scenes/`, while every other "level‑like" scene lives in `Scenes/Levels/`.
- **Referenced by:** `project.godot:14` `run/main_scene="uid://m2oqym1qilyn"` — **by UID only**, which is why path‑grep audits always flag it "unused".
- **Use:** black‑loading / boot scene.
- **Recommendation:** move to `Scenes/Levels/` (does not need a path change since main scene references it by UID, but keep the `.uid` intact).
INSTRUCTION: ignore.

### 1.5 `Scenes/Levels/` — non‑level files mixed with the levels
Multiple scripts whose domain is UI/control/HUD are filed together with the actual level scenes:

| File | Attached by | Use |
|---|---|---|
| `rich_text_label.gd` | `menu.tscn:9` | RichTextLabel flicker/anim script |
| `rich_text_label_2.gd` | `menu.tscn:10` | variant |
| `rich_text_label_4.gd` | `menu.tscn:8` | variant |
| `rich_text_label_10.gd` | `menu.tscn:13` | variant |
| `game_over_control.gd` | `game_over.tscn:4` | game‑over screen logic |
| `button.gd` | `resources_counting.tscn:8` | generic Button helper |
| `main_light.gd` | `spaceship_interior.tscn:31` | interior lighting |
| `tutorial_area.gd` … `tutorial_area8.gd` | `Tutorial.tscn:22,23,25–29` (7 of 8 wired) | tutorial trigger zones |
| `input_guide_admin.gd` | `Level_Day1/2/3.tscn`, `Tutorial.tscn` | InputGuide controller (see 1.2) |

- **Dead sibling on disk:** `tutorial_area3.gd` is **never attached** to any scene (`Tutorial.tscn` wires 1,2,4,5,6,7,8 only) — an orphan script in the wrong folder.
- Misc level‑adjacent orphans also here: `tutorial.gd` (15 B), `space_winds_sfx.gd`, `spaceship_cable.gd`, `spaceship_interior.gd`.
- **Recommendation:** move UI/control scripts to `Scenes/UI/` kept per‑scene; delete `tutorial_area3.gd` or wire it.
INSTRUCTION: do whats detailed in Recommendation and re-point its references.

### 1.6 `Scenes/Modulars/asteroid.gd` — a full space body filed as a "module"
- `asteroid.gd` `extends BodySetup` (a full `RigidBody2D` space body with `calculate_damage_and_pieces`), but it lives among the pure composition components (`hurt_module`, `gravity_module`, …).
- **Referenced by:** `Scenes/Asteroids/asteroid_small.tscn`, `asteroid_medium.tscn`, `asteroid_big.tscn` (script attachment).
- **Use:** current asteroid behavior — a space body, not a composable child module.
- **Recommendation:** move to `Scenes/Asteroids/` to preserve the "Modulars = composable components" invariant.
INSTRUCTION: move file and re-point its references.

### 1.7 `Scenes/Player/mothership.tscn` — the mothership is a level object, not a player asset
- `res://scenes/player/mothership.tscn` (+ `mothership_control.gd`, `mothership_enter_area.gd`). Note: there is **no `mothership.gd`** — only `mothership_control.gd` / `mothership_enter_area.gd`.
- **Referenced by:** `Level_Day1.tscn:11`, `Level_Day2.tscn:10`, `Level_Day3.tscn:11`, `Tutorial.tscn:11`; driven by `Scenes/Levels/input_guide_admin.gd:15‑48`.
- **Use:** the mothership objective structure + entrance area in each level.
- **Recommendation:** move to `Scenes/Spaceship/` or `Scenes/Levels/mothership/`.
INSTRUCTION: move file and re-point its references.

---

## 2. Disorganized folders

### 2.1 Twin sprite roots: `Sprites/` **and** `Sprites(main)/`
Two sibling asset roots with parallel/overlapping content — neither is authoritative:
- `Sprites/background.png` **and** `Sprites(main)/background.png` both exist.
- Deimos art split across both: `Sprites/DeimosHands/` (HoldingBook/, Idle/, IdleBook/, MachineButton/, Meleca/, MovingPagesBook/, Nananinanao/, Deimos‑Sheet.png) vs `Sprites(main)/Deimos/`.
- Alien/enemy art duplicated: `Sprites/Aliens/` vs `Sprites(main)/Enemies/`.
- Both roots also host loose top‑level images (`Sprites/` → `background.png`, `tileset.png`, `Baren.png`, `Black_hole.png`, `Explosion_Sheet.png`, `Ship_Mid.png`, `asteroids.tres`; `Sprites(main)/` → `logo.png`, `Nave_final.png`, `bookTileset.png`, `background.png`, …).
- **Referenced from:** ~44 `.tscn`/`.gd` files throughout the project (every `Sprites(main)/…` `path=`).
- **Recommendation:** merge into one sprite root and rename (see 3.2).
INSTRUCTION: do as recommended and re-point its references.

### 2.2 `Sound Effects/` — loose stragglers at root + many subfolders
Root of the folder mixes direct files with organized subfolders (`Ambience/`, `Asteroids/`, `Collecting/`, `Enemies/`, `Player/`, `Shoot/`, `Spaceship/`, `UI/`). Root‑level files still **in use** (survivors of the asset purge):
- `burn.mp3` → `sun.tscn:7`;
- `gulp.mp3` → `Scenes/BlackHoles/black_hole.tscn:8`, `supermassive_black_hole.tscn:8`;
- `sfx_morte1.wav` → `Scenes/Player/player.tscn:24`;
- `tech1.mp3` → `player.tscn:11`; `tech2.mp3` → `player.tscn:13`;
- `value_up3.wav` → `resources_counting.tscn:7`, `Scenes/Spaceship/resources_machine.tscn:9`.
- **Recommendation:** file each into the matching subfolder (Shoot/Player died → Player/, SFX card rewards → Collecting/, …).
INSTRUCTION: ask me where each file should go.

### 2.3 `Scenes/Levels/` grab‑bag (duplicate of §1.5)
One folder holds multiple distinct responsibilities: level scenes (`Level_Day1/2/3.tscn`, `Tutorial.tscn`, `menu.tscn`, `game_over.tscn`, `resources_counting.tscn`, `spaceship_interior.tscn`), UI controls, tutorial zones, HUD-ish scripts, and lighting. See §1.5 table for the non‑level residents.
INSTRUCTION: ignore.

### 2.4 `Scenes/Enemies/` — contains an unrelated `hook.gd`
- `res://scenes/enemies/hook.gd` (2.0 KB) has no enemy association — appears to be a misplaced mechanic/utility script.
- Also present: a stray backup `enemy_vermin.tscn9100188928.tmp` (garbage — see §4.1).
- **Referenced by:** none found (orphan).
- **Recommendation:** relocate or remove `hook.gd`; purge the `.tmp`.
INSTRUCTION: rename to "matriarch_hook" and re-point its references.

### 2.5 `Scenes/SpaceBodies/` — "picked" planets buried in a subfolder while duplicates stay at root
- Live‑used planet variants live in `PickedPlanets/`: `planet_medium.tscn`, `planet_medium2.tscn`, `planet_small1.tscn`, `planet_small2.tscn` (each referencing `Sprites(main)/Planetas/*` textures).
- Root still holds near‑duplicates: `planet_big1.tscn`, `planet_medium2.tscn` (same basename as the PickedPlanets one!), plus `planet.gd`, `sun.*`, `body_setup.gd`, `boss_planet_day_3.gd`, `random_planet.gd`, dead/duplicated `body_*`, `orbit*`/`path_*`.
- `Moons/` subfolder still exists: `Moon1.tscn`, `Moon3.tscn`, `static_rotation.gd` (referenced by `PickedPlanets/planet_medium.tscn` → `Moon1.tscn`, `planet_small1.tscn` → `Moon3.tscn`).
- **Recommendation:** flatten — move the 4 used variants to root and delete/merge the stale duplicates (reconcile the duplicated `planet_medium2.tscn` basename).
INSTRUCTION: do as recommended and re-point its references.

### 2.6 `Scenes/` root — level/gameplay files at the top level
Directly under `Scenes/`: `boss_fight.tscn`, `resource.tscn`, and the stray test `test_gravity_changes.gd`. These belong under `Levels/`, `Modulars/`, `Enemies/` or `Tests/`.
- `test_gravity_changes.gd` is a stray dev/test script at the scene root (not part of any folder) — misplaced + unregistered with the test suite.
INSTRUCTION: delete all the listed files. (PS: DO NOT delete start_limbo)

---

## 3. Redundant / erroneous / non‑descriptive filenames

### 3.1 ~~`BackHoles` typo~~ — **RESOLVED on disk** (doc staleness remains)
- On disk there is **only `Scenes/BlackHoles/`** and every reference already matches: `Level_Day1.tscn:25,27`, `Level_Day2.tscn:24,25`, `Level_Day3.tscn:25,26`, `Tutorial.tscn:21`, and `Tests/Unit/black_hole_test.gd:8‑9` (→ `res://scenes/black_hole/black_hole.{gd,tscn}`). The rename landed (via merge of `main`).
- **The docs are stale:** `AGENTS.md` and `UNUSED_CODE.md` still describe `BackHoles/` as on‑disk / describe the test as failing. Update those two docs to the current truth.
INSTRUCTION: update docs.

### 3.2 `Sprites(main)/` — parentheses in a folder name
- Folders with `(`/`)` must be path‑quoted in every `path=`/`load()`/`preload()` → referenced in **~44 files** (e.g. all `Asteroids/*.tscn`, all `Bullets/*.tscn`, all `Cutscenes/*.tscn`, `menu.tscn`, `player.tscn`, `diary_database.gd`, `input_guide.gd`, `input_guide_unit.tscn`).
- Rename to `Sprites_main` (or merge per §2.1) and re‑point all references + keep UIDs.
INSTRUCTION: will be merged as per §2.1 and re-pointed.

### 3.3 Non‑ASCII / accented / spaced / mixed‑case filenames (fragile on many filesystems)
- `Sprites(main)/Planetas/PlanetaMédio3.png` (accent) → `PickedPlanets/planet_medium2.tscn:4`.
- `Sprites(main)/Planetas/planetaMédio2.png` (mixed case + accent) → `PickedPlanets/planet_medium.tscn:4`.
- `PlanetaPequeno3.png` / `PlanetaPequeno2.png` → `planet_small1.tscn:4` / `planet_small2.tscn:4`.
- `Lua2.png`, `Lua4.png` → `Moon1.tscn:4`, `Moon3.tscn:4`.
- **Spaces in paths:** `Sprites(main)/Enemies/Matriarca_Morta Partes do Corpo/` → `boss.tscn:8` (`A Matriarca Morta.png`), `boss.tscn:13` (`A Matriarca Morta_head.png`).
- **Leading space:** `Fonts/ Commodore Pixelized v1.2.ttf` (space in the font folder name).
- **Recommendation:** ASCII‑only, no spaces; `snake_case` consistently.
INSTRUCTION: rename the files following godot's code conventions and style guide. re-point its references.

### 3.4 Numeric, non‑descriptive image names still in active use
- `Sprites(main)/TemporaryPlanets/66888997 (3).png` → `Tutorial.tscn:5`.
- `2524948669.png`, `2121290283.png`, `2733907768.png` → used across `Level_Day1/2/3.tscn` + `Tutorial.tscn` (12 references total).
- Numeric PNGs also remain in `TemporaryPlanets/NewMap/` (subfolder with unnamed number files).
- sqlite‑style names give zero hint of content — **recommend** descriptive renames (`planet_day1_a.png`, …) or accept as temporary.
INSTRUCTION: yes, rename those files following godot's code conventions and style guide. re-point its references.

### 3.5 `(n)`‑suffixed duplicates (survivors) + mixed PT/EN naming
- `(1)/(2)/(3)` space‑suffixed duplicates were mostly purged; the surviving active one is `66888997 (3).png` (§3.4). The `(n)` convention is inherently fragile (copy of a copy).
- **Language mixing:** Portuguese names coexist with English across assets/scripts — `Sound Effects/sfx_morte1.wav` (PT "death"), PT planet names (`PlanetaMédio3`, `PlanetaPequeno2`, `Lua`), `resources_counting.tscn` (Portuguese spelling "contagem") vs English instrument names (`boss_matriarch.png` style). Pick one namespace.
- **Typo sprawl mirrored in folders:** `Scenes/Levels/resources_counting.tscn` (correct) vs a stray `.tmp` at `Scenes/resoures_counting.tscn…)` ("resoures" — two r's — misspelling, §4.1).
INSTRUCTION: translate all names to english.

### 3.6 `*_pallete` misspelling — **live and heavily used**
- `pallete` should be `palette`. Still referenced in 16+ spots:
  - `Sprites(main)/asteroid_default_pallete.png` → `asteroid_big.tscn:18`, `asteroid_medium.tscn:10`, `asteroid_pieces.tscn:8`, `asteroid_small.tscn:15`.
  - `pink_asteroid_pallete.png`, `red_asteroid_pallete.png`, `yellow_asteroid_pallete.png` → across those four asteroid scene files.
- **Recommendation:** rename to `*_palette.*` and re‑point references (keep UIDs).
INSTRUCTION: do as recommended.

### 3.7 `basic_bullet.gd` name doesn't describe its dual role
- The generic name "basic" also powers **`super_bullet.tscn`** (both scenes attach the one root script). The filename understates behavior.
- **Recommendation:** rename to `player_bullet.gd` (shared) and update both `path=` + test constant.
INSTRUCTION: do as recommended. re-point all references.

---

## 4. Extra filesystem findings

1. **Godot `.tmp` garbage files (editor crash/backup leftovers)** — purge all:
   - `Scenes/resoures_counting.tscn37057794388.tmp`
   - `Scenes/Levels/Level_Day3.tscn3361966689.tmp`
   - `Scenes/Levels/spaceship_interior.tscn7042025547.tmp`
   - `Scenes/Levels/spaceship_interior.tscn7142520275.tmp`
   - `Scenes/Enemies/enemy_vermin.tscn9100188928.tmp`
   - `Scenes/SpaceBodies/asteroids.tscn6620681510.tmp`
   - `Scenes/SpaceBodies/planet_big1.tscn8380983310.tmp`
   - `Scenes/UI/Settings/settings_container.tscn199836163.tmp`
   - `Fonts/ Commodore Pixelized v1.2.ttf6851770003.tmp`
2. **`resoures_counting` (typo)** — the `Scenes/resoures_counting.tscn…tmp` misspells "resources"; conflicts with the real `Scenes/Levels/resources_counting.tscn`.
3. **Inconsistent `.uid` hygiene** — some `.gd`/`.tscn` have `.uid` sidecars, other sibling resources don't (e.g. `start_limbo.gd.uid` exists; many `Modulars/*.tscn` have none). Harmless but inconsistent; let the editor normalize.
4. **Stray test file** `Scenes/test_gravity_changes.gd` (+ `.uid`) — dev script at scene root, not in `Tests/`.
5. **`Sound Effects/` root `.import` sidecars** linger for the root stragglers (§2.2) — clutter while the loose files remain.
6. **`DEFAULT UNUSED_DOCS`** — referenced in AGENTS.md's layout sketch but does **not exist** on disk; stale doc reference.
INSTRUCTION: fix but keep everything functional.
---

## 5. Already resolved / deleted (no action)

| Item | Status |
|---|---|
| `Scenes/BackHoles/*` → `Scenes/BlackHoles/` | Rename landed (references all updated); only docs stale (§3.1) |
| `Scenes/Modulars/asteroid-old.gd` | Deleted |
| `paths_hub.gd` (empty autoload stub) | Deleted; autoload entry removed from `project.godot` |
| `planet.tscn`, `planet_giant.tscn`, `planet_medium1.tscn` | Deleted |
| `Sprites/AlienShooterGB_1.0/`, `Sprites(main)/Placeholders/` | Deleted |
| ~130 unused images/audio/video/shader files | Deleted (see `UNUSED_RESOURCES.md`) |
| `DEFAULT UNUSED_DOCS` | Does not exist (doc reference only) |

---

## Summary counts

- **Misplaced files (A):** 7 item groups (§1.1–1.7).
- **Disorganized folders (B):** 6 item groups (§2.1–2.6).
- **Name problems (C):** 7 item groups (§3.2–3.8; §3.1 resolved).
- **Extra findings:** 6 (§4.1–4.6).
- **Deleted/resolved:** 7 categories (§5).

> Highest‑impact fixes, in order: kill the `.tmp` garbage → unify `Sprites/` + `Sprites(main)/` → flatten `SpaceBodies/` (resolve duplicated `planet_medium2.tscn` basename) → ASCII/`snake_case` renames (accents, spaces, `pallete`, `(n)` duplicates) → move root‑level scripts into their thematic folders.

EXTRA INSTRUCTION: YOU MAY RENAME ANY FILE TO FOLLOW GOOD PRACTICES, GODOT'S CONVENTION AND STYLE GUIDE. REMEMBER TO ALWAYS RE-POINT ITS REFERENCES AND KEEP EVERYTHING WORKING EXACTLY AS BEFORE.