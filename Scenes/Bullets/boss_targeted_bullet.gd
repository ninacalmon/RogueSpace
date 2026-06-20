extends BossBullet
class_name BossTargetedBullet

@export var turn_speed: float = 1.5
@onready var sprite_2d: Sprite2D = $Sprite2D

var target: Node2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if target and is_instance_valid(target):
		var desired_direction = global_position.direction_to(
			target.global_position
		)

		direction = direction.slerp(
			desired_direction,
			turn_speed * delta
		).normalized()

	global_position += direction * speed * delta

	rotation = direction.angle()

	lifespan -= delta

	if lifespan <= 0:
		decay_and_delete()

func _on_area_entered(area: Area2D):
	if area is Bullet:
		decay_and_delete()

func decay_and_delete():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d, "scale", Vector2.ONE * 0.1, 0.5)
	await tween.finished
	call_deferred("queue_free")
