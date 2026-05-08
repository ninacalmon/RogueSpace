extends BodySetup
class_name _Asteroid

@onready var break_sound: AudioStreamPlayer = $BreakSound

@export var damage_module: DamageModule
@export var broken_piece_scene: PackedScene
@export var base_endurance: float = 200
@export var base_pieces_amount: int = 10
@export var minimum_damage_amount: float = 100

@export var enemy_scene: PackedScene

var endurance: float
var pieces_amount: int
var pieces_amount_bonus: float = 1.5
var initial_pieces_amount: int

var parent

var states: Array[String] = [
	"initial_state",
	"shedding_state",
	"broken_state",
	]

var original_sprite_scale: Vector2
var original_collision_radius: float


func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()

	sprite.frame = randi_range(0, 1)

	original_sprite_scale = sprite.scale
	original_collision_radius = collision.shape.radius

	mass *= sprite.scale.x
	pieces_amount = int(base_pieces_amount * sprite.scale.x)
	initial_pieces_amount = pieces_amount
	endurance = base_endurance * (sprite.scale.x * 0.5)
	minimum_damage_amount *= (sprite.scale.x * 0.5)

	damage_module.damage_taken.connect(_on_damage_taken)

	parent = get_parent()


func _on_damage_taken(amount: float, causer: RigidBody2D):
	if amount < minimum_damage_amount:
		return
	
	SFXManager.play_sound(break_sound)
	
	if causer is Player:
		handle_player_damage(amount, causer)
	else:
		var damage = amount * 0.5
		var damage_proportion = damage / endurance
		endurance -= damage
		if endurance <= 0: total_break()
		else: call_deferred("shed_pieces", damage_proportion)

func handle_player_damage(amount: float, player: Player):
	if !player.can_destroy:
		return

	var damage = amount
	var damage_proportion = damage / endurance
	endurance -= damage
	if endurance <= 0: total_break()
	else: call_deferred("shed_pieces", damage_proportion)
	spawn_critters()


func shed_pieces(damage_proportion: float):
	var pieces_to_shed: int = int((pieces_amount * damage_proportion))
	pieces_amount -= pieces_to_shed
	for p in pieces_to_shed:
		var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		new_piece.global_position = global_position \
		+ Vector2(randi_range(-50, 50), randi_range(-50, 50))
		#add_collision_exception_with(new_piece)
		#gravitational_field._add_collision_exception_with(new_piece)
		parent.call_deferred("add_child", new_piece)
	scale_down(0.8, 0.2)

func total_break():
	if pieces_amount == initial_pieces_amount:
		pieces_amount = ceil(pieces_amount * pieces_amount_bonus)
	var pieces_to_break: int = pieces_amount
	for p in pieces_to_break:
		var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		new_piece.global_position = global_position \
		+ Vector2(randi_range(-20, 20), randi_range(-20, 20))
		parent.call_deferred("add_child", new_piece)
	await scale_down(0)
	queue_free()

func scale_down(amount: float, duration: float = 0.5):
	var sprite_new_scale = sprite.scale * amount
	var collision_new_scale = collision.scale * amount
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(sprite, "scale", sprite_new_scale, duration)
	tween.parallel().tween_property(collision, "scale", collision_new_scale, duration)
	await tween.finished

func spawn_critters():
	print("oi")
	var chance = randi_range(1, 20)
	if chance != 1:
		return
	var enemy_amount = randi_range(2, 5)
	for e in enemy_amount:
		var new_enemy: Enemy = enemy_scene.instantiate()
		new_enemy.player = get_tree().get_first_node_in_group("Player_Group")
		new_enemy.global_position = global_position \
		+ Vector2(randi_range(-20, 20), randi_range(-20, 20))
		parent.call_deferred("add_child", new_enemy)
