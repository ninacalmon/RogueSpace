extends Control
class_name DiaryPageController

@export var animation_delay: float = 1

@onready var page_left: DiaryPage = $PagesContainer/PageL
@onready var page_right: DiaryPage = $PagesContainer/PageR

@onready var button_left: Button = $ButtonsContainer/ButtonL
@onready var button_right: Button = $ButtonsContainer/ButtonR

var current_spread: int = 0


func _ready():
	button_left.pressed.connect(_on_prev_pressed)
	button_right.pressed.connect(_on_next_pressed)


func open_diary():
	current_spread = _get_max_spread()
	show_spread()

func show_spread():
	var day_left = current_spread * 2 
	var day_right = day_left + 1

	var max_day = StatsManager.day

	#LEFT PAGE
	var data_left = DiaryDatabase.get_page(day_left)


	if day_left > max_day:
		data_left = DiaryDatabase.EMPTY_PAGE

	page_left.setup_page(day_left, data_left)


	#RIGHT PAGE
	var data_right = DiaryDatabase.get_page(day_right)

	if day_right > max_day:
		data_right = DiaryDatabase.EMPTY_PAGE

	page_right.setup_page(day_right, data_right)


	_update_buttons()


# ========================
# Navigation
# ========================

func _on_next_pressed():
	var max_spread = _get_max_spread()

	if current_spread < max_spread and !HandsEventBus.hand_is_busy:
		current_spread += 1
		HandsEventBus.page_next.emit()
		await get_tree().create_timer(animation_delay).timeout
		show_spread()


func _on_prev_pressed():
	if current_spread > 0 and !HandsEventBus.hand_is_busy:
		current_spread -= 1
		HandsEventBus.page_prev.emit()
		await get_tree().create_timer(animation_delay).timeout
		show_spread()


# ========================
# Helpers
# ========================

func _get_max_spread() -> int:
	var max_day = StatsManager.day
	return int(floor(max_day / 2.0))


func _update_buttons():
	var max_spread = _get_max_spread()

	var is_left_disabled = current_spread <= 0
	var is_right_disabled = current_spread >= max_spread

	button_left.disabled = is_left_disabled
	button_right.disabled = is_right_disabled

	button_left.modulate.a = 0.0 if is_left_disabled else 1.0
	button_right.modulate.a = 0.0 if is_right_disabled else 1.0
