extends Control

@export var noise_evolution_speed : float = 0.1
@export var pos_amount : float = 12
@export var rot_amount : float = 5
@export var return_speed : float = 5
@export var multiplier_return_speed : float = 3
@export var smoothing_speed : float = 12

var noise_y = 0
var start_pos
var start_rot
var multiplier : float = 1

@onready var noise : FastNoiseLite = FastNoiseLite.new()

func _ready():
	randomize()
	noise.seed = randi()
	
	set_start_vals()
	await get_tree().process_frame

func set_start_vals():
	start_pos = position
	start_rot = rotation

func set_mult(mult):
	multiplier = mult

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	noise_y += noise_evolution_speed * delta
	multiplier = lerp(multiplier, 1.0, delta * multiplier_return_speed)
	
	var offset : Vector2 = Vector2()
	offset.x = noise.get_noise_2d(noise.seed, noise_y)
	offset.y = noise.get_noise_2d(noise.seed * 2, noise_y)
	var rotation = noise.get_noise_2d(noise.seed * 3, noise_y)
	
	position = lerp(position, start_pos + offset * pos_amount * multiplier, delta * smoothing_speed)
	rotation = lerp(rotation, start_rot + rotation * rot_amount * multiplier, delta * smoothing_speed)
#	rect_position = lerp(rect_position, start_pos, delta * return_speed)
