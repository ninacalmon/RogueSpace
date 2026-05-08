extends BodySetup
class_name Asteroid

@export var base_endurance: float = 200
@export var minimum_damage_amount: float = 100
@export var pieces_amount_min: int = 5
@export var pieces_amount_max: int = 10
@export var will_spawn_critters: bool
@export_range(0, 100, 1) var critters_chance_percentage: int
@export var critters_amount_min: int = 2
@export var critters_amount_max: int = 5

@export var damage_module: DamageModule
@export var broken_piece_scene: PackedScene
@export var enemy_scene: PackedScene

@onready var break_sound: AudioStreamPlayer = $BreakSound

var endurance: float
var pieces_amount_bonus: float = 1.5
var impact_count: int 

var parent

var original_sprite_scale: Vector2
var original_collision_radius: float


func _ready() -> void:
	##setup
	if gravitational_field: gravitational_field.initialize()
	if body_randomizer: body_randomizer.initialize(sprite, collision)

	sprite.frame = randi_range(0, 0)

	original_sprite_scale = sprite.scale
	original_collision_radius = collision.shape.radius

	endurance = base_endurance

	parent = get_parent()

	damage_module.damage_taken.connect(_on_damage_taken)


func _on_damage_taken(amount: float, causer: RigidBody2D):
	print(amount)
	if amount < minimum_damage_amount:
		return
	
	impact_count += 1
	
	if causer is Player:
		handle_player_damage(amount, causer)
	else:
		handle_external_damage(amount)

func handle_player_damage(amount: float, player: Player):
	if !player.can_destroy:
		return

	var damage = amount
	var damage_proportion = damage / endurance
	endurance -= damage
	#if endurance <= 0: total_break()
	#else: 
	break_sound.volume_db = -15
	SFXManager.play_sound(break_sound)
	call_deferred("shed_pieces", damage_proportion)
	spawn_critters()


func handle_external_damage(amount: float):
	var damage = amount * 0.5
	var damage_proportion = damage / endurance
	endurance -= damage
	#if endurance <= 0: total_break()
	#else: 
	break_sound.volume_db = -22
	SFXManager.play_sound(break_sound)
	call_deferred("shed_pieces", damage_proportion)


func shed_pieces(damage_proportion: float):
	var amount_to_shed: int = randi_range(pieces_amount_min, pieces_amount_max) * int(damage_proportion)
	var amount_to_shed_per_impact: int = ceil(amount_to_shed / impact_count)
	
	for p in amount_to_shed_per_impact:
		var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		new_piece.global_position = global_position \
		+ Vector2(randi_range(-50, 50), randi_range(-50, 50))
		parent.call_deferred("add_child", new_piece)
	scale_down(0.8, 0.2)

#func total_break():
	#
	#if pieces_amount == initial_pieces_amount:
		#pieces_amount = ceil(pieces_amount * pieces_amount_bonus)
	#var pieces_to_break: int = pieces_amount
	#for p in pieces_to_break:
		#var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		#new_piece.global_position = global_position \
		#+ Vector2(randi_range(-20, 20), randi_range(-20, 20))
		#parent.call_deferred("add_child", new_piece)
	#await scale_down(0)
	#queue_free()

func scale_down(amount: float, duration: float = 0.5):
	var sprite_new_scale = sprite.scale * amount
	var collision_new_scale = collision.scale * amount
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(sprite, "scale", sprite_new_scale, duration)
	tween.parallel().tween_property(collision, "scale", collision_new_scale, duration)
	await tween.finished

func spawn_critters():
	if !will_spawn_critters:
		return
	var chance = randi_range(0, 100)
	if chance < critters_chance_percentage:
		var critters_amount = randi_range(critters_amount_min, critters_amount_max)
		for i in critters_amount:
			var new_critter: Enemy = enemy_scene.instantiate()
			new_critter.player = get_tree().get_first_node_in_group("Player_Group")
			new_critter.global_position = global_position \
			+ Vector2(randi_range(-20, 20), randi_range(-20, 20))
			parent.call_deferred("add_child", new_critter)
