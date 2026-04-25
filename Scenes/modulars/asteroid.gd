extends BodySetup
class_name Asteroid

@export var damage_module: DamageModule
@export var broken_piece_scene: PackedScene
@export var base_endurance: float = 80
@export var base_pieces_amount: int = 10

var endurance: float
var pieces_amount: int
var pieces_amount_bonus: float = 1.5
var initial_pieces_amount: int

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

	original_sprite_scale = sprite.scale
	original_collision_radius = collision.shape.radius

	mass *= sprite.scale.x
	pieces_amount = int(base_pieces_amount * sprite.scale.x)
	initial_pieces_amount = pieces_amount
	endurance = base_endurance * (sprite.scale.x * 0.3)

	damage_module.damage_taken.connect(_on_damage_taken)


func _on_damage_taken(amount: float):
	var damage = amount * 0.2
	## damage / endurance -> quanto % do endurance esse damage representa
	var damage_proportion = damage / endurance
	print("damage_proportiion: ", damage_proportion, " endurance: ", endurance, " damage: ", damage)
	endurance -= damage
	if endurance <= 0: total_break()
	else: shed_pieces(damage_proportion)


func shed_pieces(damage_proportion: float):
	print("SHEDDING.  damage proportion: ", damage_proportion)
	var pieces_to_shed: int = int((pieces_amount * damage_proportion))
	print("total: ", pieces_amount, "  shedding: ", pieces_to_shed)
	pieces_amount -= pieces_to_shed
	for p in pieces_to_shed:
		var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		new_piece.global_position = global_position \
		+ Vector2(randi_range(-50, 50), randi_range(-50, 50))
		#add_collision_exception_with(new_piece)
		#gravitational_field._add_collision_exception_with(new_piece)
		get_parent().add_child(new_piece)


func total_break():
	print("BREAKING")
	if pieces_amount == initial_pieces_amount:
		pieces_amount = ceil(pieces_amount * pieces_amount_bonus)
	var pieces_to_break: int = pieces_amount
	for p in pieces_to_break:
		var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		new_piece.global_position = global_position \
		+ Vector2(randi_range(-20, 20), randi_range(-20, 20))
		get_parent().add_child(new_piece)
	queue_free()
