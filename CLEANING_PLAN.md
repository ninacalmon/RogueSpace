# Code Cleaning & Standardization Plan — `vox vacui`

> Working plan for a full code-cleaning and standardization pass over the RogueSpace
> (`vox vacui`) Godot 4.5 project. Target: **Godot GDScript Style Guide**
> (https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html),
> as already codified in this repo's `STYLE.md`.
>
> **Hard constraint:** code must keep functioning **exactly** as before. Only formatting,
> ordering, and removal of dead code are allowed — no logic, behavior, or architecture
> changes (per `STYLE.md`'s *Preservation of Functionality* and *Variable Re-assertion* rules).

---

## Baseline facts (from codebase survey)

- **158** `.gd` scripts: 122 under `scenes/`, 22 under `tests/`, 14 under `autoloads/`.
- Tabs already used for indentation everywhere — no space-indent problems.
- No `&&` / `||` operators anywhere (already `and` / `or`).
- No single-quoted string literals.
- `.editorconfig` is minimal (`charset = utf-8` only) — should be enriched (Phase 5).
- **72 uncommitted changes** are already in the working tree from the folder
  reorganization → these must be committed as a checkpoint first (Phase 0).
- Existing test baseline: **210 tests / 22 suites, all green** (known harmless exit-101
  RID/texture-leak tail).

---

## Findings to fix (measured)

| # | Category | Hits | Where |
|---|----------|------|-------|
| 1 | `extends` before `class_name` (declaration-order swap) | **62 files** | nearly every `class_name` script |
| 2 | Single-line enums (`enum State { IDLE, CHASE }`) | **6** | input_guide, boss, enemy_basic, enemy_larvae, enemy_vermin, deimos_hands |
| 3 | One-line `if x: stmt` (must split) | **47** | asteroid, black_hole×2, cutscene, death_setup, menu_buttons_control, etc. |
| 4 | `!x` → `not x` | **~30** | asteroid_fragments, black_hole, matriarch_hook, clickable_highlight, door, diary, etc. |
| 5 | Lines > 100 chars | **48** | diary_database(10), menu_test(7), map_generator(3), enemy_vermin(3), indicator(2), … |
| 6 | Debug `print()` noise | **29** | "bonuuuus", "PERFORMED ATTACK!", "chameiiii", "clcik", "coco", music banner, etc. |
| 7 | Commented-out dead code | **~209 lines / 25 files** | big block in `input_guide.gd` (~30), `globals.gd` commented vars, `diary_database`, etc. |
| 8 | Malformed const | **1** | `stats_manager.gd:55` `const FUEL_IMPULSE_USE_STEP: = 0.5` (tests pin value `0.5`) |
| 9 | Funcs missing `->` return type | **~204** | throughout scenes/autoloads (tests already use `-> void`) — *deferred, see Q3* |
| 10 | Banner / decorative PT-BR divider comments | heavy | `enemy_vermin.gd` is **68% comments** (304/442), bullet_shooter 49%, mouse 49% |
| 11 | Doc-vs-disk drift in `UNUSED_CODE.md` | several | `asteroid-old.gd`, `paths_hub.gd`, root `basic_bullet.gd` already gone → marks stale |

### Already clean (verified — do **not** touch)
Tabs everywhere, no `&&` / `||`, no single quotes, no space-before-paren on calls,
`resources_counting.tscn` referencing, and the test files.

---

## Decisions (confirmed with the user)

1. **Phase 0 checkpoint** → commit/stage the 72-file reorganization first so cleaning diffs stay reviewable.
2. **Debug prints** → remove all **29**.
3. **Return types (`-> void`)** → **skip for now** (no type annotations added in this pass).
4. **Ordering** → **full reorder including methods** (top-level declaration order + virtual-callback-before-interface method order). No renames.
5. **Dead files** → **delete after per-file re-verification** (`git rm` confirmed orphans).

---

## Phases

> **Verification gate runs after EVERY phase:**
> 1. `godot --headless --editor --quit --path .` → exit 0, no parse errors.
> 2. Full gdUnit4 suite:
>    ```bash
>    cd <project> && export GODOT_BIN=/usr/local/bin/godot && \
>    timeout 240 ./addons/gdUnit4/runtest.sh -a res://tests --ignoreHeadlessMode
>    ```
>    → 210/210, 22 suites (exit 101 = harmless leak-warning tail). A single failure halts its
>    suite file — fix and re-run before continuing.
> 3. Per-folder `git diff` review vs. the pre-phase snapshot — only formatting/ordering/removal, no semantics.

---

### Phase 0 — Checkpoint (baseline)

1. Stage the 72-file reorganization diff and commit it as a clean checkpoint
   (e.g. `chore: repoint refs after folder reorganization`). Confirm `git status` clean
   before proceeding (docs commits from earlier tasks land here too).
2. Optional: snapshot current runtime state once via the MCP runtime harness (Phase 4
   re-verifies, so this is just a sanity baseline).

### Phase 1 — Safe mechanical formatting (script-assisted, zero-logic)

Work **per folder** so diffs stay reviewable. Suggested order: `autoloads/` →
`scenes/modulars/` → `scenes/space_bodies/` → `scenes/asteroids/` → `scenes/black_hole/` →
`scenes/bullets/` → `scenes/player/` → `scenes/enemies/` → `scenes/spaceship/` →
`scenes/levels/` → `scenes/ui/` → `scenes/cutscenes/` → `tests/`.

1.1 **Class declaration order** — `class_name` above `extends`: **62 files** (script-assisted line swap).
1.2 **Enum expansion** — single-line `enum State { A, B }` → multi-line with trailing comma: **6 files**.
1.3 **One-line `if x: stmt` split** — **47 sites** (each to two lines; combined `if !x: return`
    handled together with the `not` rewrite).
1.4 **`!x` → `not x`** — **~30 sites** across ~20 files; skips `!=` and PT-BR string
    exclamations; each hit reviewer-confirmed.
1.5 **Malformed const fix** — `stats_manager.gd:55` → `const FUEL_IMPULSE_USE_STEP: float = 0.5`
    (same value; test pins literal `0.5` — still passes).
1.6 **Long-line wraps (>100)** — **48 lines**, wrapped per guide (2-indent continuations,
    `and`/`or` at line start); pathological strings left intact.
1.7 **Whitespace hygiene** — trailing newline at EOF, no trailing whitespace, comment spacing
    `# text` (not `#text`; `#region`/`#endregion` untouched).
1.8 **Ambiguous-inference tidy** — the two `:=` float sites (`shake_module.gd:4`,
    `looping_text.gd:7`) are already correct via `:=`; no change unless the parser warns.

### Phase 2 — Dead-code removal

2.1 **Remove commented-out code** — ~209 lines/25 files: the dead `show_guide/hide_guide`
    block in `input_guide.gd` (~30 lines), `globals.gd` commented vars, `diary_database.gd`
    commented dict, disabled `#freeze = …` lines, etc.
2.2 **Remove the 29 debug `print()` lines** (explicitly approved) — `level_transition.gd:13`,
    music banner, `boss.gd:243-246`, `enemy_vermin.gd:85,133,136`, `bullet_shooter.gd:62`,
    `player.gd:94,233`, `focus_module.gd:21,46,60`, `door.gd:87`, `menu_buttons_control` /
    `input_guide_admin` noise, etc. — plus any prints that become orphaned-empty as a result.
2.3 **Banner/divider comment cleanup** — collapse decorative `# ----…` dividers and oversized
    header banners (e.g. `enemy_vermin.gd` 68% comment ratio); keep genuine explanatory/doc
    comments and the PT-BR diary text verbatim.
2.4 **Delete confirmed-orphan assets** — fresh per-file reference audit of `UNUSED_CODE.md`
    §1.4 candidates (`Moon1.tscn`, `Moon3.tscn`, planet variants), then `git rm` each confirmed
    orphan; all deletions logged.
2.5 **Doc sync** — mark resolved items in `UNUSED_CODE.md` (incl. already-gone
    `asteroid-old.gd`, `paths_hub.gd`, root `basic_bullet.gd`); update
    `FILESYSTEM_MISTAKES.md` / `AGENTS.md` if layout changes.

### Phase 3 — Full method/variable ordering (per user decision)

3.1 **Reorder top-level sections** per guide: `@tool` → `class_name` → `extends` → doc →
    signals → enums → consts → statics → `@export` → vars → `@onready` — each script audited
    for misplaced declarations.
3.2 **Reorder methods**: `_init` → `_enter_tree` → `_ready` → `_process` → `_physics_process`
    → other virtuals → overridden customs → remaining public → private (`_`-prefixed) methods
    → inner classes. Pure movement (no renaming); GDScript resolution is order-independent,
    diffs reviewed per file.
3.3 **No var/function renames** — would break `.tscn` wiring; deferred to a separate advisory
    report.

### Phase 4 — Verification (after every phase)

4.1 `godot --headless --editor --quit --path .` → exit 0, no parse errors.
4.2 `runtest.sh -a res://tests --ignoreHeadlessMode` → 210/210, 22 suites.
4.3 **MCP runtime smoke** (post Phase 2 + Phase 3): boot `start_limbo` → cutscene → menu →
    keyboard-Enter on focused Start → Tutorial → Player movement via `input_action`; logs
    clean of new errors.
4.4 Per-folder `git diff` sanity — only formatting/ordering/removal, no semantics.

### Phase 5 — Config sync

5.1 Enrich `.editorconfig` with:
    ```ini
    indent_style = tab
    indent_size = tab
    max_line_length = 100
    trim_trailing_whitespace = true
    insert_final_newline = true
    ```
5.2 Update `STYLE.md` / `AGENTS.md` only if a step changed a documented convention;
    `research_report.md` remains a historical snapshot (untouched).

---

## Out of scope (flagged, not executed)

- Bug-fix logic changes.
- Node/function renames.
- Spot-fixing known smells: `has_energy_in_spaceship` trigger-setter
  (`globals.gd:31-35`), `player_have_perfurator = true` default (`stats_manager.gd:49`),
  the commented-out `Globals.level` (dead code in `resources_counter_texts.gd`).

These are reported as advisories only — reach/ask design before touching.

---

## Execution order summary

```
Phase 0  checkpoint commit
Phase 1  mechanical formatting (per-folder, script-assisted)
   → gate: rescan + tests + diff
Phase 2  dead-code removal + print() removal + orphan deletion
   → gate: rescan + tests + MCP smoke
Phase 3  full ordering (declarations + methods)
   → gate: rescan + tests + MCP smoke
Phase 4  final verification (rescan + tests + smoke)
Phase 5  .editorconfig + docs sync
```

Every phase boundary ends with a status checkpoint communicated to the user before moving on.