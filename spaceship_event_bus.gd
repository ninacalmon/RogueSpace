extends Node

@warning_ignore("unused_signal")
signal focus_on(zoom_in_amount: float, zoom_offset: Vector2, emitter: Node2D)

@warning_ignore("unused_signal")
signal focus_off

@warning_ignore("unused_signal")
signal resource_count_finished

@warning_ignore("unused_signal")
signal resource_count_started(duration: float)

@warning_ignore("unused_signal")
signal focus_changed(focus: bool, subject: Node2D)

@warning_ignore("unused_signal")
signal resources_spent()
