extends BodySetup
class_name Asteroid

@export var base_endurance: float = 200
@export var minimum_damage: float = 70
@export var minimum_external_damage: float = 160
@export var endur_to_pieces_proportion: int = 8
@export var will_spawn_critters: bool
@export_range(0, 100, 1) var critters_chance_percentage: int
@export var critters_amount_min: int = 2
@export var critters_amount_max: int = 5

@export var damage_module: DamageModule
@export var broken_piece_scene: PackedScene
@export var enemy_scene: PackedScene

@export var palette_options: Array[Texture]

@export var is_fix: bool

@onready var break_sound: AudioStreamPlayer = $BreakSound
@onready var critter_sound: AudioStreamPlayer = $CritterSound

var endurance: float
var first_impact_bonus: float = 1.5

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
	
	if damage_module:
		damage_module.damage_taken.connect(_on_damage_taken)
	
	if palette_options.size() > 0:
		var new_palette = palette_options.pick_random()
		sprite.material.set_shader_parameter("new_palette", new_palette)


func _on_damage_taken(damage: float, causer: RigidBody2D):
	if causer is Player and damage > minimum_damage:
		handle_player_damage(damage, causer)

	if !(causer is Player) and damage > minimum_external_damage:
		handle_external_damage(damage)
	
	if endurance <= 0:
		await scale_down(0)
		call_deferred("queue_free")


func handle_player_damage(damage: float, player: Player):
	if !player.can_destroy:
		return

	var bonus_multiplier: float = 1.0

	if damage >= base_endurance and endurance == base_endurance:
		print("bonuuuus")
		bonus_multiplier = first_impact_bonus

	var dict: Dictionary = calculate_damage_and_pieces(damage, bonus_multiplier)
	var actual_damage = dict["actual_damage"]
	var pieces = dict["pieces"]
	
	endurance -= actual_damage

	break_sound.volume_db = -15
	SFXManager.play_sound(break_sound)

	call_deferred("shed_pieces", pieces)
	if will_spawn_critters:
		spawn_critters(true)


func handle_external_damage(damage: float):
	var dict: Dictionary = calculate_damage_and_pieces(damage)
	var actual_damage = dict["actual_damage"]
	var pieces = dict["pieces"]
	
	endurance -= actual_damage

	break_sound.volume_db = -22
	SFXManager.play_sound(break_sound)

	call_deferred("shed_pieces", pieces)
	if will_spawn_critters:
		spawn_critters()


func shed_pieces(pieces: int):
	for p in pieces:
		var new_piece: RigidBody2D = broken_piece_scene.instantiate()
		new_piece.global_position = global_position \
		+ Vector2(randi_range(-50, 50), randi_range(-50, 50))
		parent.call_deferred("add_child", new_piece)
	scale_down(0.8, 0.2)


func spawn_critters(is_player: bool = false):
	var chance = randi_range(0, 100)

	if chance <= critters_chance_percentage:
		var critters_amount = randi_range(critters_amount_min, critters_amount_max)
		for i in critters_amount:
			var new_critter: Enemy = enemy_scene.instantiate()
			new_critter.player = get_tree().get_first_node_in_group("Player_Group")
			new_critter.global_position = global_position \
			+ Vector2(randi_range(-20, 20), randi_range(-20, 20))
			parent.call_deferred("add_child", new_critter)
		if is_player:
			SFXManager.play_sound(critter_sound)

func scale_down(amount: float, duration: float = 0.5):
	var sprite_new_scale = sprite.scale * amount
	var collision_new_scale = collision.scale * amount
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(sprite, "scale", sprite_new_scale, duration)
	tween.parallel().tween_property(collision, "scale", collision_new_scale, duration)
	await tween.finished

## Return value is dictionary with contract { "actual_damage", "pieces" }
func calculate_damage_and_pieces(damage, bonus_multiplier: float = 1.0) -> Dictionary:
	var actual_damage = min(damage, endurance)
	var pieces: int = ceil((actual_damage / endur_to_pieces_proportion) * bonus_multiplier)
	print(pieces)

	return {
		"actual_damage": actual_damage,
		"pieces": pieces
	}

func _process(_delta: float) -> void:
	if is_fix:
		linear_velocity = Vector2.ZERO
