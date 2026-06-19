extends Control
class_name DiaryPageController

@export var animation_delay: float = 1

@onready var page_left: DiaryPage = $PagesContainer/PageL
@onready var page_right: DiaryPage = $PagesContainer/PageR

@onready var button_left: Button = $ButtonsContainer/ButtonL
@onready var button_right: Button = $ButtonsContainer/ButtonR

var current_day: int = 1

func _ready():
	button_left.pressed.connect(_on_prev_pressed)
	button_right.pressed.connect(_on_next_pressed)


func open_diary():
	current_day = StatsManager.day
	show_day()

func show_day():
	var max_day = StatsManager.day
	var day_data = DiaryDatabase.get_day(current_day)

	# LEFT
	if current_day <= max_day:
		page_left.setup_left(current_day, day_data["left"])
	else:
		page_left.setup_left(0, DiaryDatabase.EMPTY_DAY["left"])

	# RIGHT
	if current_day <= max_day:
		page_right.setup_right(day_data["right"])
	else:
		page_right.setup_right(DiaryDatabase.EMPTY_DAY["right"])

	_update_buttons()

# ========================
# Navigation
# ========================

func _on_next_pressed():
	if current_day < StatsManager.day:
		current_day += 1
		show_day()


func _on_prev_pressed():
	if current_day > 1:
		current_day -= 1
		show_day()


# ========================
# Helpers
# ========================

func _get_max_spread() -> int:
	var max_day = StatsManager.day
	return int(floor(max_day / 2.0))


func _update_buttons():
	var max_day = StatsManager.day

	var is_left_disabled = current_day <= 1
	var is_right_disabled = current_day >= max_day

	button_left.disabled = is_left_disabled
	button_right.disabled = is_right_disabled

	button_left.modulate.a = 0.0 if is_left_disabled else 1.0
	button_right.modulate.a = 0.0 if is_right_disabled else 1.0
