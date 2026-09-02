# TESTS.md — Testing Guide for Rogue Space

This document explains how to run the project's unit tests (via the **gdUnit4** framework), the quirks you may hit, and how to work around them. It also documents how to write new tests and how the test folders are organized.

---

## Framework

The project uses [gdUnit4](https://github.com/godot-gdunit-labs/gdUnit4) for unit testing. It is installed as an editor plugin at `res://addons/gdUnit4/` and enabled in `project.godot` (`[editor_plugins]`).

> **Important:** gdUnit4 is a **separate** system from the Godot AI MCP plugin's own test runner. Do not confuse the two — see [Quirks & Workarounds](#quirks--workarounds).

---

## Test Folder Organization

Tests live under `res://tests/`, organized by feature/subsystem, with a `Unit` subfolder for unit tests:

```
res://tests/
└── Menu/
    └── Unit/
        └── menu_test.gd        # gdUnit4 test suite for the Menu scene
```

### Rules

- The **scan root** is `res://tests/` (configurable via `[gdunit4] settings/test/test_lookup_folder="Tests"` in `project.godot`).
- The scanner walks that root recursively and picks up any `.gd` file whose class **extends `GdUnitTestSuite`**.
- Each test method must be named with the **`test_` prefix** (e.g. `test_buttons_exist`).
- Follow the pattern: one test suite per scene / unit, placed under `tests/<feature>/unit/`.

---

## Creating a Test Suite

Create a GDScript that extends `GdUnitTestSuite` and uses the built-in `assert_that(...)` helpers.

### Minimal skeleton

```gdscript
extends GdUnitTestSuite

# Runs once before the whole suite.
func before() -> void:
	pass

# Runs before each test case.
func before_test() -> void:
	pass

# Runs after each test case.
func after_test() -> void:
	pass

# Runs once after the whole suite (cleanup).
func after() -> void:
	pass

func test_something():
	assert_that(1 + 1).is_equal(2)
```

### Loading a scene under test

```gdscript
var menu_control: Control

func before() -> void:
	var scene := load("res://scenes/levels/menus/menu.tscn") as PackedScene
	menu_control = scene.instantiate()
	add_child(menu_control)
	# Let _ready() and deferred logic run before asserting state:
	await get_tree().process_frame
	await get_tree().process_frame

func after() -> void:
	if is_instance_valid(menu_control):
		menu_control.queue_free()
```

> **Note:** Instantiate the scene yourself in `before()`. Do not assume node properties are populated immediately after `add_child()` — add one or two `await get_tree().process_frame` calls before asserting.

### Common assertions

| Assertion | Purpose |
|-----------|---------|
| `assert_that(x).is_equal(y)` | Value equality |
| `assert_that(x).is_not_null()` | Object/node exists |
| `assert_that(x).is_true()` / `is_false()` | Boolean state |
| `assert_that(x).is_less_equal(y)` | Numeric <= |
| `assert_that(x).is_greater_equal(y)` | Numeric >= |
| `assert_that(callable.is_connected(target, method)).is_true()` | Signal connection |

> **Important — correct API names:** use `is_less_equal` / `is_greater_equal`, **not** `is_less_or_equal` / `is_greater_or_equal`. The latter methods do **not** exist in gdUnit4 and cause `'Nonexistent function'` errors.

---

## How to Run the Tests

### Quickest way (CLI / headless)

From the project root:

```bash
export GODOT_BIN=/usr/local/bin/godot
./addons/gdUnit4/runtest.sh -a res://tests --ignoreHeadlessMode
```

- `-a res://tests` tells gdUnit4 to scan the `res://tests/` folder for suites.
- `--ignoreHeadlessMode` is required when running with `--headless` (see [Quirks](#quirks--workarounds)).
- To run a **single suite**, pass its path: `-a res://tests/menu/unit/menu_test.gd`.

The script prints a per-test result (PASSED / FAILED), an overall summary, and writes reports to `reports/report_<N>/` (XML + HTML).

A clean run looks like:

```
Statistics: 6 test cases | 0 errors | 0 failures | 0 flaky | 0 skipped | 0 orphans | PASSED
Executed test cases : (6/6)
Exit code: 0
```

### Via the Godot editor (UI)

The **GdUnit Inspector** panel (docked in the editor) provides:
- **Button Bar** — run single tests or the full suite.
- **Test Run Overview Tree** — run a test / suite from a hierarchical view.
- **Run Overall** — run all discovered tests.

You can also right-click a `.gd` test file or a `tests/` folder in the **FileSystem dock** and choose the gdUnit run/debug option from the context menu.

---

## Quirks & Workarounds

### 1. Godot AI's `test_run` MCP tool is NOT gdUnit4

The Godot AI MCP plugin exposes a `test_run` tool that reports:

```
No test suites found in res://tests/
```

**Why:** that tool scans the hard-coded `res://tests/` folder and only accepts scripts extending its own `McpTestSuite` class (files named `test_*.gd`). It knows nothing about gdUnit4.

**Workaround:** use the gdUnit4 CLI (`runtest.sh`) or the GdUnit Inspector instead. The `test_run` MCP tool is a dead end for gdUnit4 suites.

### 2. `Headless mode is not supported!` (exit 103)

When running with `--headless`, gdUnit4 refuses to start unless told otherwise.

**Workaround:** add `--ignoreHeadlessMode`:

```bash
./addons/gdUnit4/runtest.sh -a res://tests --ignoreHeadlessMode
```

Caveat: with this flag, tests relying on **real UI input events** (`InputEventMouse`, key presses) will **not** behave correctly in headless mode, because the engine does not transport input events headlessly. Prefer programmatic assertions (visibility, properties, signal connections) for headless tests.

### 3. Suite stops after a failed test (only the first N tests run)

The XML report may say `tests="6"` but the CLI reports `Executed test cases: (2/2)`. gdUnit4 **halts a suite after a test fails**, so the remaining methods in that suite never run.

**Workaround:** keep tests independent so one failure doesn't hide the rest. If a test asserts state you're unsure about (e.g. a button's default visibility), verify the actual scene/script behavior first, then assert that — a failure near the top of the file prevents the rest from executing.

### 4. Scene state is not ready immediately

Reading child nodes or their properties right after `instantiate()`/`add_child()` can yield `null` nodes or stale values (e.g. a button whose `visible` is set in the root script's `_ready()`).

**Workaround:** always `await get_tree().process_frame` (often twice) in `before()` before asserting.

### 5. The `-a` path must match the configured lookup folder

gdUnit4 only discovers suites under the folder configured in `project.godot`:

```
[gdunit4]
settings/test/test_lookup_folder="Tests"
```

If you point `runtest.sh -a` at a folder outside that tree, tests won't be found. Keep tests under the configured scan root.

### 6. Harmless warnings at exit

You may see warnings like `1 RID allocations ... leaked` or `Parameter "RenderingServer::get_singleton()" is null` right after `Exit code: 0`. These are cosmetic teardown warnings and do **not** affect the test results.

---

## Project-Specific Example: the Menu Suite

`tests/menu/unit/menu_test.gd` covers the Menu scene (`res://scenes/levels/menus/menu.tscn`):

| Test | Verifies |
|------|----------|
| `test_buttons_exist` | Continue / Start / Settings / Controls / Exit buttons exist |
| `test_buttons_are_visible` | Correct default visibility (Start/Settings/Exit visible; Continue/Controls hidden until a save day exists) |
| `test_settings_sliders_exist` | Master / Music / Effects sliders exist |
| `test_sliders_have_correct_ranges` | Slider min/max ranges are valid |
| `test_ui_sounds_nodes_exist` | UISounds > HoverSFX / ClickSFX nodes exist |
| `test_button_click_signals_connected` | Buttons are wired to the menu script's handlers |

> The `Continue` and `Controls` buttons are **intentionally hidden** when no save game exists (`menu_buttons_control.gd` sets `_continue.visible = StatsManager.day != 0`). The visibility test asserts this real behavior rather than blindly expecting `true`.