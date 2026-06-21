extends Area2D
class_name BossBullet

@export var speed: float = 600
@export var damage: float = 1
@export var lifespan: float = 3.0
@onready var sprite_2d: Sprite2D = $Sprite2D

var direction: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	randomize()
	sprite_2d.flip_v = bool(randi() % 2)
	#area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	
	global_position += direction * speed * delta
	lifespan -= delta
	
	if lifespan <= 0:
		queue_free()

func _on_body_entered(body: PhysicsBody2D):
	if !(body is Boss):
		queue_free()

#func _on_area_entered(area: Area2D):
	#if area is Bullet:
		#queue_free()
