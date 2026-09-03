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

- [x] Stage the 72-file reorganization diff and commit it as a clean checkpoint
  (e.g. `chore: repoint refs after folder reorganization`). Confirm `git status` clean
  before proceeding (docs commits from earlier tasks land here too).
- [x] Optional: snapshot current runtime state once via the MCP runtime harness (Phase 4
  re-verifies, so this is just a sanity baseline).

> **Status:** DONE (checkpoint commit `f853418`). Gate passed (rescan clean, 210/210).

### Phase 1 — Safe mechanical formatting (script-assisted, zero-logic)

Work **per folder** so diffs stay reviewable. Suggested order: `autoloads/` →
`scenes/modulars/` → `scenes/space_bodies/` → `scenes/asteroids/` → `scenes/black_hole/` →
`scenes/bullets/` → `scenes/player/` → `scenes/enemies/` → `scenes/spaceship/` →
`scenes/levels/` → `scenes/ui/` → `scenes/cutscenes/` → `tests/`.

- [x] 1.1 **Class declaration order** — `class_name` above `extends`: **62 files** (script-assisted line swap).
- [x] 1.2 **Enum expansion** — single-line `enum State { A, B }` → multi-line with trailing comma: **6 files**.
- [x] 1.3 **One-line `if x: stmt` split** — **47 sites** (each to two lines; combined `if !x: return`
	handled together with the `not` rewrite).
- [x] 1.4 **`!x` → `not x`** — **~30 sites** across ~20 files; skips `!=` and PT-BR string
	exclamations; each hit reviewer-confirmed.
- [x] 1.5 **Malformed const fix** — `stats_manager.gd:55` → `const FUEL_IMPULSE_USE_STEP: float = 0.5`
	(same value; test pins literal `0.5` — still passes).
- [x] 1.6 **Long-line wraps (>100)** — **48 lines**, wrapped per guide (2-indent continuations,
	`and`/`or` at line start); pathological strings left intact.
- [x] 1.7 **Whitespace hygiene** — trailing newline at EOF, no trailing whitespace, comment spacing
	`# text` (not `#text`; `#region`/`#endregion` untouched).
- [x] 1.8 **Ambiguous-inference tidy** — the two `:=` float sites (`shake_module.gd:4`,
	`looping_text.gd:7`) are already correct via `:=`; no change unless the parser warns.

> **Status:** DONE. Gate passed (headless rescan exit 0, zero parse errors; gdUnit4 **210/210**,
> report_13). `class_name`/`extends` now contiguous per guide.

### Phase 2 — Dead-code removal

- [x] 2.1 **Remove commented-out code** — ~209 lines/25 files: the dead `show_guide/hide_guide`
	block in `input_guide.gd` (~30 lines), `globals.gd` commented vars, `diary_database.gd`
	commented dict, disabled `#freeze = …` lines, etc.
- [x] 2.2 **Remove the 29 debug `print()` lines** (explicitly approved) — `level_transition.gd:13`,
	music banner, `boss.gd:243-246`, `enemy_vermin.gd:85,133,136`, `bullet_shooter.gd:62`,
	`player.gd:94,233`, `focus_module.gd:21,46,60`, `door.gd:87`, `menu_buttons_control` /
	`input_guide_admin` noise, etc. — plus any prints that become orphaned-empty as a result.
	(33 prints actually removed during the pass.)
- [x] 2.3 **Banner/divider comment cleanup** — collapse decorative `# ----…` dividers and oversized
	header banners (e.g. `enemy_vermin.gd` 68% comment ratio); keep genuine explanatory/doc
	comments and the PT-BR diary text verbatim.
- [x] 2.4 **Delete confirmed-orphan assets** — fresh per-file reference audit of `UNUSED_CODE.md`
	§1.4 candidates (`Moon1.tscn`, `Moon3.tscn`, planet variants), then `git rm` each confirmed
	orphan; all deletions logged.
- [x] 2.5 **Doc sync** — mark resolved items in `UNUSED_CODE.md` (incl. already-gone
	`asteroid-old.gd`, `paths_hub.gd`, root `basic_bullet.gd`); update
	`FILESYSTEM_MISTAKES.md` / `AGENTS.md` if layout changes.

> **Status:** DONE. Gate passed (rescan clean; gdUnit4 **210/210** report_14; MCP runtime smoke
> boot→cutscene→menu→tutorial→player movement verified at the re-org paths).

### Phase 3 — Full method/variable ordering (per user decision)

- [x] 3.1 **Reorder top-level sections** per guide: `@tool` → `class_name` → `extends` → doc →
	signals → enums → consts → statics → `@export` → vars → `@onready` — each script audited
	for misplaced declarations.
- [x] 3.2 **Reorder methods**: `_init` → `_enter_tree` → `_ready` → `_process` → `_physics_process`
	→ other virtuals → overridden customs → remaining public → private (`_`-prefixed) methods
	→ inner classes. Pure movement (no renaming); GDScript resolution is order-independent,
	diffs reviewed per file.
- [x] 3.3 **No var/function renames** — would break `.tscn` wiring; deferred to a separate advisory
	report.

> **Status:** DONE — reorder applied via `/tmp/reorder.py` to all **136** `.gd` files under
> `scenes/` + `autoloads/` (121 changed, 15 already conformant). Three script bugs were found
> and fixed during the pass (see **Session log** below): (a) column-0 comments inside function
> bodies, (b) multiline strings resuming at column 0 / blank lines, (c) closing-banner comments
> that must stay with the preceding body. Gate passed: content-preservation + idempotency checks
> clean across all files, headless rescan **0** parse errors, gdUnit4 **210/210** report_15,
> and MCP runtime smoke boot→cutscene→menu→Tutorial with Player movement confirmed working.

### Phase 4 — Verification (after every phase)

- [x] 4.1 `godot --headless --editor --quit --path .` → exit 0, no parse errors.
- [x] 4.2 `runtest.sh -a res://tests --ignoreHeadlessMode` → 210/210, 22 suites.
- [x] 4.3 **MCP runtime smoke** (post Phase 2 + Phase 3): boot `start_limbo` → cutscene → menu →
	keyboard-Enter on focused Start → Tutorial → Player movement via `input_action`; logs
	clean of new errors.
- [x] 4.4 Per-folder `git diff` sanity — only formatting/ordering/removal, no semantics.

> **Status:** DONE. 4.1 rescan clean (MCP `filesystem_manage` scan, 0 delta, editor logs empty);
> 4.2 gdUnit4 **210/210** 22 suites, report_16; 4.3 MCP runtime smoke boot→cutscene→menu→Tutorial
> with Player movement (`linear_velocity.x=14.0`, position 0→160.4); 4.4 normalized-code diff
> check across all 140 modified `.gd` files confirmed only documented transforms (see **Session
> log**). Pre-existing harmless warning: `Scenes/ui/indicator.gd:84` `tr` shadows `Object.tr()` —
> not introduced by cleaning.

### Phase 5 — Config sync

- [x] 5.1 Enrich `.editorconfig` with:
	```ini
	indent_style = tab
	indent_size = tab
	max_line_length = 100
	trim_trailing_whitespace = true
	insert_final_newline = true
	```
- [x] 5.2 Update `STYLE.md` / `AGENTS.md` only if a step changed a documented convention;
	`research_report.md` remains a historical snapshot (untouched).

> **Status:** DONE. 5.1 rewrote `.editorconfig` (added the five keys above plus a `[*.md]`
> override `trim_trailing_whitespace = false` to protect Markdown hard line breaks). 5.2 docs
> synced: `AGENTS.md` (malformed-const note → fixed; root `basic_bullet.gd` note → moved to
> `scenes/bullets/player_bullet.gd`), `UNUSED_CODE.md` (§3.1 const, §3.5 black_hole, §3.6
> modulars marked RESOLVED with current on-disk paths), `FILESYSTEM_MISTAKES.md` (§1.1 root
> bullet, §2.2 gulp.mp3 path, §3.1 black-hole docs, §3.7 bullet rename, §5 table). No
> convention changed, so `STYLE.md` untouched; `TESTS.md` + `UNUSED_RESOURCES.md` grepped clean.

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
Phase 0  checkpoint commit                       [x] DONE  (f853418)
Phase 1  mechanical formatting (per-folder, script-assisted) [x] DONE
   → gate: rescan + tests + diff                 [x] PASSED (210/210, report_13)
Phase 2  dead-code removal + print() removal + orphan deletion [x] DONE
   → gate: rescan + tests + MCP smoke            [x] PASSED (210/210, report_14)
Phase 3  full ordering (declarations + methods)  [x] DONE  (136 files via /tmp/reorder.py)
   → gate: rescan + tests + MCP smoke            [x] PASSED (210/210, report_15)
Phase 4  final verification (rescan + tests + smoke) [x] DONE   (210/210, report_16)
Phase 5  .editorconfig + docs sync               [x] DONE
```

Every phase boundary ends with a status checkpoint communicated to the user before moving on.

---

## Session log

Working notes for the LLM sessions that executed this plan — resume guidance for the next session.

### Session 1 — Phases 0–2 (completed)
- **Where:** prior session (`ses_fa10d2cedffeJf4rl2GGdYhPOj` handoff); executed Phase 0 (checkpoint
  commit `f853418`), Phase 1 (mechanical formatting), and Phase 2 (dead-code/prints/orphans).
- **Outcomes:** 60 files `class_name`-above-`extends`; 6 enums expanded; 47 one-line `if`s split;
  `!x`→`not x`; malformed const fixed; >100-char lines paren-wrapped; 33 debug `print()` removed;
  banners collapsed; orphans re-verified.
- **Gates:** Phase 1 → rescan clean + gdUnit4 **210/210** report_13. Phase 2 → rescan clean +
  210/210 report_14 + MCP smoke boot→cutscene→menu→tutorial→movement at the re-org paths.
- **Critical lesson learned:** never write a perl alternation with a bare `^$`/`||` empty fragment —
  it matches every line and EMPTIES the file (corrupted `camera.gd`, `indicator.gd`,
  `matriarch_hook.gd`). Restore via `git show HEAD:<CAPITALIZED-tracked-path>`; prefer the
  `edit`/`write` tools over perl on files with uncommitted changes; `wc -l` after any perl.

### Session 2 — Phase 3 full reorder (completed)
- **What:** full top-level + method ordering per the Godot style guide across **136** `.gd` files
  under `scenes/` + `autoloads/` (121 changed, 15 already conformant), driven by `/tmp/reorder.py`
  (Python; run with the mise shim `~/.local/share/mise/installs/python/3.14.7/bin/python3`).
- **Script bugs found & fixed during the pass:**
  1. Column-0 comment lines inside function bodies ended the block early → detached body lines
	 (files: `enemy_basic.gd`, `mothership_enter_area.gd`, `warnings_control.gd`,
	 `resources_label.gd`). Fix: look-ahead past blanks; if the next non-blank line is indented,
	 the comment is inside the body.
  2. Multiline strings resuming at column 0 / as blank lines inside bodies were detached
	 (`warnings_control.gd`, `tutorial_area2/4/5/6/8.gd`, `tutorial_control.gd`,
	 `power_up_setup.gd`, `diary_database.gd`, `resources_label.gd`). Fix: string-state tracking
	 (`line_str_state`) seeded on the decl line and threaded through the body loop.
  3. Closing-banner comments (`## ===…`) directly following indented body content were displaced.
	 Fix: if a column-0 comment is a pure `=-*~_` rule AND the immediately preceding line is
	 non-blank + indented, it stays with the preceding body. Text dividers (`# Core behavior`, …)
	 still travel with the next block (correct).
- **Post-fix hardening:** `class_name`/`extends` emitted contiguously (blank removed); every mass
  apply re-restored all 136 files from `/tmp/baseline` before re-running.
- **Verification:** content-preservation (non-blank-line multiset equal) + idempotency (reorder of
  reorder = same output) clean across all 136 files; class_name/extends blank violations = 0;
  headless rescan **0** parse errors; gdUnit4 **210/210** report_15; MCP smoke
  boot→cutscene→menu→Tutorial, Player movement verified.
- **Environment notes:** `rtk read` collapses function bodies into a summary — use
  `cat -n`/`sed`/`grep` for raw verification. Mouse clicks FAIL on the menu
  (MOUSE_MODE_CAPTURED + fake-mouse needs joypad) — use keyboard Enter on the focused Start
  button, and give the Start button a full press+release (the `pressed` signal needs it).
- **Baseline snapshot:** `/tmp/baseline` holds pre-Phase-3 copies of all 136 `.gd` files for
  isolated diff review (`diff /tmp/baseline/<path> <path>`). May be cleared once Phase 4 passes.

### Session 3 — Phases 4–5 (completed)
- **What:** final verification sweep + config/docs sync.
- **Phase 4:** (4.1) MCP `filesystem_manage(op=scan)` → `scan_completed:true`,
  `global_classes_registered_delta:0`, editor logs empty; (4.2) gdUnit4 **210/210** 22 suites,
  report_16, exit 101 = harmless RID/texture-leak tail; (4.3) MCP runtime smoke
  boot→cutscene→menu→Tutorial→Player movement (`linear_velocity.x=14.0`, position 0→160.4),
  game logs clean; (4.4) normalized-code symmetric-difference check across all 140 modified `.gd`
  files (`/tmp/code_diff_check.sh`) — only documented transforms: `!x`→`not x`, one-line if
  splits, long-line paren wraps, enum expansions, print/comment removals, pure const/function
  moves, malformed-const fix. No net-positive outliers; no `.tscn` touched. Pre-existing harmless
  warning `Scenes/ui/indicator.gd:84` `tr` shadows `Object.tr()`.
- **Phase 5:** (5.1) rewrote `.editorconfig` (tab indent, max_line_length 100,
  trim_trailing_whitespace, insert_final_newline + `[*.md]` trim off to protect hard breaks).
  (5.2) Docs synced — `AGENTS.md` (malformed-const + root-bullet notes), `UNUSED_CODE.md`
  (§3.1/3.5/3.6 RESOLVED), `FILESYSTEM_MISTAKES.md` (§1.1/§2.2/§3.1/§3.7/§5 table), all with
  current on-disk paths (`scenes/black_hole/`, `scenes/modulars/`, `scenes/bullets/player_bullet.gd`).
  `STYLE.md` untouched (no convention changed); `TESTS.md` + `UNUSED_RESOURCES.md` grepped clean.
- **Environment notes:** NTFS `/mnt/c` is case-insensitive, so `ls` matches both `Scenes/` and
  `scenes/` — verify casing by grepping reference paths, not by listing. `game_eval` node paths
  need the `/root/` prefix (`/root/Main/Player`), else the game parks at a debugger break.

### MCP / editor performance — why commands lag, and how to avoid it
**Symptom:** Godot MCP requests (input, scene-tree reads, evals) take far too long to answer;
plugin log shows every request tagged `[defer]` and repeated `readiness -> importing → ready`
cycles.

**Root cause:** running the CLI headless rescan
(`godot --headless --editor --quit --path .`) **while the Godot editor is open** on the same
project. The rescan writes to `.godot/` cache files (`filesystem_cache10`,
`global_script_class_cache.cfg`, `uid_cache.bin`) that the open editor is watching; the editor
detects the change and enters an import/re-scan loop. **During `importing`, every MCP request is
deferred until the editor's main thread settles** — that is the perceived lag. A stuck loop shows
up in the plugin log as `[defer] game_command ...` + `game_command timeout` + an
`ignored mcp:hello with no active game run`. A second contributor: the editor's Debugger Errors tab
can hold stale rows from a previously-broken state (old `res://` paths, unresolved `class_name`
bases); these reference dead paths and force repeated failed recompiles of dependent scripts.

**How to solve / avoid:**
1. **Do not run the CLI headless rescan while the editor is open.** Either close the editor first,
   or use `filesystem_manage(op=scan)` via MCP instead — it runs through the editor's own scan and
   settles cleanly (it returned `scan_completed: true, global_classes_registered_delta: 0` when
   used).
2. If lag is already present, clear the stale error rows: `logs_clear(clear_debugger_errors=true)`
   (cleared 187 log entries + the stale Errors-tab rows). Then re-scan once via MCP and confirm
   `readiness: ready`.
3. If delays persist, **restart the editor once** — it rebuilds caches fresh against the current
   (fixed) files and the churn stops.

### Retrieving prior-session detail for the next session
If a future session needs information from the sessions above that is not captured in this plan
(the full handoff context, tool transcripts, intermediate states), it can retrieve it the same way
the resume prompt references a past session: use the **`read_session`** tool with the session ID
(e.g. `ses_fa10d2cedffeJf4rl2GGdYhPOj` for Session 1). This returns the raw conversation transcript
of that session. Keep this plan's notes as the primary reference and only pull the transcript when a
specific detail is missing here.

### Resume checklist for the next session
1. Confirm `git status` working tree: **142 modified files** uncommitted (Phase 1–3 changes) —
   do **not** commit unless the user asks.
2. **Phase 4** (final verification): headless rescan → gdUnit4 210/210 → MCP runtime smoke → per-folder
   `git diff` sanity.
3. **Phase 5**: enrich `.editorconfig` + sync docs (`UNUSED_CODE.md`, `UNUSED_RESOURCES.md`,
   `FILESYSTEM_MISTAKES.md`, `AGENTS.md`, `TESTS.md`; do **not** edit `research_report.md`).
4. Once Phase 5 is done, present the checkpoint to the user for commit decision.
