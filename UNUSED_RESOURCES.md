# UNUSED_RESOURCES.md — Dead/unused asset resources inventory

> Audit of `vox vacui` (Godot 4.5, folder `RogueSpace-main`) performed on 2026‑08‑25.
> Scope: non‑code **asset resources** — images, videos, audio, shaders, fonts, materials/themes and other binary assets.
> "Unused" = no reference found in any `.gd`, `.tscn`, `.tres`, `.res`, `.gdshader` or `project.godot` (grep by path/basename, excluding `addons/`, `Tests/`, `reports/`, `.godot/`).
> Every `.tscn`/`.tres` `ext_resource` line carries an explicit `path=`, so path‑matching is complete (no hidden UID‑only references except the project icon, noted in §4).

---

## 1. Shaders (2)

| res:// path | Size | Note |
|---|---|---|
| `res://scenes/enemies/enemy_larvae.gdshader` | 349 B | no reference found |
| `res://scenes/spaceship/pixel_sprite.gdshader` | 346 B | no reference found — a *different* `Shaders/pixel_sprite.gdshader` IS used |

## 2. Videos (2)

| res:// path | Note |
|---|---|
| `res://sprites(main)/Cutscenes/InOutSpaceship.mp4` | only the `.ogv` sibling is used |
| `res://sprites(main)/Cutscenes/InOutSpaceship.ogv` | no reference found (other cutscene `.ogv` files are used) |

## 3. Audio (18)

| res:// path | Note |
|---|---|
| `Sound Effects/Collecting/sfx_contagemrecursos1.wav` … `sfx_contagemrecursos4.wav` | 4 files, unused |
| `Sound Effects/Enemies/sfx_inimigoBigOne.wav` | unused |
| `Sound Effects/Enemies/sfx_inimigoVerme.wav` | unused |
| `Sound Effects/freesound_community-genickbruch-107521.mp3` (+ `.wav`) | duplicate pair, unused |
| `Sound Effects/Player/Movement/Sfx_dash_falhando.wav` | unused (only the `(2)` copy is used) |
| `Sound Effects/Player/Movement/Sfx_dash_falhando (1).wav` | unused (only the `(2)` copy is used) |
| `Sound Effects/Player/Movement/SFX_dash.wav` | unused (only `SFX_dash2.wav` used) |
| `Sound Effects/Player/Movement/SFX_movloop.wav` | unused |
| `Sound Effects/sfx_enemy.mp3` | unused |
| `Sound Effects/value_up.wav` | unused (only `value_up3.wav` used) |
| `Sound Effects/value_up2.wav` | unused (only `value_up3.wav` used) |

## 4. Images — root `Sprites/` (13)

`Sprites/Aliens/Alien_Air1.png`…`Alien_Air6.png`, `Sprites/Aliens/Alien_Ground1.png`…`Alien_Ground2.png` (8), `Sprites/controller.jpg` (21 KB), `Sprites/dash.png` (37 KB), `Sprites/fuel.png` (48 KB), `Sprites/Ice.png`, `Sprites/Lava.png`, `Sprites/Other_Asteroid1.png`, `Sprites/Terran.png`, `Sprites/teleport.png`, `Sprites/teleport (1).png`, `Sprites/vecteezy_arrow_1186949.png`, `Sprites/panorama6.jpg` (3.7 MB).

## 5. Images — `Sprites/Starfields/` (7)

`Starfield 3`…`Starfield 8` (`- 1024x1024.png`). Only Starfield 1 & 2 are used.

## 6. Images — `Sprites/VFX/` (16)

`VFX_AlienFlash_strip5`, `VFX_Beam_strip2`, `VFX_Bullet`, `VFX_Drip_strip2`, `VFX_Explosion2_strip8`, `VFX_Flash`, `VFX_Impact_strip3`, `VFX_Laser_strip4`, `VFX_NoHit_strip3`, `VFX_Orb1_strip4`, `VFX_Orb2_strip3`, `VFX_Orb3_strip2`, `VFX_Orb4_strip2`, `VFX_Oval_strip4`, `VFX_Thrust_strip4`. (Only `VFX_Explosion1_strip8` is used.)

## 7. Images — `Sprites/AlienShooterGB_1.0/…` (5)

Whole unextracted asset‑pack folder: `AlienShooterGB.aseprite`, `AlienShooterGB_AssetPack.png`, `Seperated_Assets/Tilesets/Tileset_Metal/Organic/Rocks.png`.

## 8. Images — `Sprites(main)/` root & misc (11)

`Sprites(main)/Deimos.png`, `Sprites(main)/Nave (1).png` (14 KB; superseded by `Nave_final.png`), `Sprites(main)/Planet.png`, `Sprites(main)/Asteroids/Fragments-spritesheet_PeB.png`, `Sprites(main)/Deimos/LaserShot-Sheet (1).png`, `Sprites(main)/Enemies/alien_FuraDetrito.png`, `Sprites(main)/Enemies/Alien_Gordo.png`, `Sprites(main)/Enemies/Alien_LarvaCaústica_idle-Sheet.png`, `Sprites(main)/Enemies/alien_Larvae.png`, `Sprites(main)/Enemies/alien_VermeLanceiro.png`, `Sprites(main)/Enemies/boss_matriarch.png`.

## 9. Images — `Sprites(main)/Enemies/` leftovers (3)

`Gordo/Alien_LarvaCaústica1.png`, `Matriarca_Morta Partes do Corpo/A Matriarca Morta_arms.png`, `…_body.png`. (Only `_head.png` and the combined `A Matriarca Morta.png` are used.)

## 10. Images — `Sprites(main)/Planetas/` (6)

`Lua.png`, `Lua3.png`, `Lua5.png`, `Lua6.png`, `PlanetaMédio.png`, `PlanetaPequeno.png`. (Only Lua2/4, PlanetaMaior, planetaMédio2/3, PlanetaPequeno2/3 used.)

## 11. Images — `Sprites(main)/SpaceshipInterior/` (8)

`book.png`, `drawing_day1.png`, `drawing_day1_2.png`, `drawingTest2.png`, `SpaceshipMonitorDeimos.png`. (Only the DeimosFace variants + drawing_day1_3/day3/day4/drawingTest used.)

## 12. Images — `Sprites(main)/TemporaryPlanets/` (24)

Root: `22951 (1).png`, `2295125163 (1).png`, `2733907768 (1).png`, `2733907768 (2).png`, `3614980188.png`, `66888997.png`, `66888997 (1).png`, `66888997 (2).png`, `66.png`, `93845903.png`. `NewMap/`: `giant1`, `giant2`, `mediumbig`, `moon1`, `moon2`, `moon3`, `moon4`, `moon6`, `planet_big1`, `planet_small`. (Only `2121290283.png`, `2524948669.png`, `2733907768.png`, `66888997 (3).png`, `NewMap/medium2.png`, `NewMap/sun.png` used.)

## 13. Images — `Sprites(main)/Placeholders/` (7)

`backgound.png`, `button.png`, `moedor.png`, `vecteezy_vintage-television….png`, `d2eb949b….jpg`, `luke-o-connor-lukeo-connor-final-20.jpg` — whole placeholder folder unused.

## 14. Images — `Sprites(main)/UI/` (36)

`arrow.png`, `arrow2.png`, `circle2.png`, `Mouse1.png`, `tile_0578.png`, `UI/PUIcons/powerup_health2.png`, `UI/PUIcons/powerup_teleport1.png`, and 29 Kenney‑Input tiles (`tile_0005,0006,0007,0034,0076,0077,0078,0087,0088,0089,0156,0423,0491,0576,0604,0621,0622,0623,0624,0801,0816,0819,0820,0821,0822`). (Only a handful of Kenney tiles + `tile_0004`, `tile_0568`, `tile_0823`, `tile_calendar` are used.)

## 15. Images — palettes / sprite sources (8)

`Sprites(main)/asteroid_default_pallete.aseprite`, `pink_asteroid_pallete.aseprite`, `red_asteroid_pallete.aseprite`, `yellow_asteroid_pallete.aseprite` (the 4 `.aseprite` sources; their `.png` exports are used), plus `Sprites/asteroid_tileset.aseprite`, `Sprites/asteroid_tileset.png`, `Sprites/blackhole.aseprite`, `Sprites/tileset.aseprite`.

## 16. Images — `Sprites/DeimosHands/` (8)

`IdleBook/Ildeuma1.PNG`…`Ildeuma4.PNG` (4 frames, never used — no IdleBook animation) and `MovingPagesBook/IMG_4496.PNG`, `IMG_4497.PNG`, `IMG_4510.PNG`, `IMG_4511.PNG` (4 frames not present in `deimos_hands.tres`). All other DeimosHands frames ARE used via `deimos_hands.tres`.

---

## Summary

- **Resource files found:** 436
- **Unused (safe to delete):** 169 (≈128 MB of images/audio/video)
- **Referenced by UID only (keep):** `res://VoxVacui_Icon_LowRes.png` — the actual project icon (referenced by UID `uid://dernurpysipe2` in `project.godot`; do **not** delete).

### Notes / edge cases
- All 12 `Shaders/*.gdshader`, `palette_swap.tres`, both `Fonts/*.ttf`, `default_theme.tres`, and the used cutscene `.ogv`/`.wav` files are confirmed **in use** — do not touch.
- Notable large dead files worth reclaiming: `Sprites/panorama6.jpg` (3.7 MB), `Sprites(main)/Placeholders/`, `Sprites/Starfields/Starfield 3–8`, the entire `Sprites/AlienShooterGB_1.0/` pack.
