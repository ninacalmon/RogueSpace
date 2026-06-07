extends MainArea

@onready var shake_module: ShakeModule = $ShakeModule

func _ready() -> void:
	_connect_signals()

func _connect_signals():
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)

func _on_clicked():
	HandsEventBus.door_interaction.emit()
	PopUpSystem.show_text("Não está na hora ainda.")
	shake_module.shake(self, 0.2, 0.6)
