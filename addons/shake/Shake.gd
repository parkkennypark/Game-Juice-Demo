class_name Shake

extends Node

signal started_shaking

enum type {
	vector1,
	vector2,
	vector3
}

class OneShot:
	var time : float
	var time_left : float
	var strength_mult : float
	var x_mult : float
	var y_mult : float

	func _init(_time, _strength_mult, _x_mult, _y_mult):
		time = _time
		time_left = _time
		strength_mult = _strength_mult
		x_mult = _x_mult
		y_mult = _y_mult

	func subtract_time(delta):
		time_left -= delta

	func get_time_ratio():
		return time_left / time

	func is_expired() -> bool:
		return time_left <= 0

@export var base_strength: float = 1.0
@export var speed: float = 1
@export_exp_easing("attenuation") var damping_curve : = 1.0 # (float, EASE)
#export var target_node_path: NodePath
#export var property: String
#export var property_type: type

var is_shaking_indefinitely : bool
var amplitude : float
var offset : Vector3 
var timer
var one_shots : Array[OneShot] = []

@onready var noise : FastNoiseLite = FastNoiseLite.new()
var noise_y = 0

func _ready():
	randomize()
	
	noise.seed = randi()
	noise.frequency = 1
#	noise.period = 4
#	noise.octaves = 2

func _process(delta):
#	if shaking:
#		process_shaking(delta)
	
	if !is_shaking():
		return
	
	var noise_vector = get_noise_vector()
	
	if is_shaking_indefinitely:
		var this_offset = noise_vector * amplitude
		offset += this_offset
	
	noise_y += speed / 1.0
	for one_shot in one_shots:
		var damping = ease(one_shot.get_time_ratio(), damping_curve)
		var this_offset = noise_vector * damping * base_strength * one_shot.strength_mult
		this_offset.x *= one_shot.x_mult
		this_offset.y *= one_shot.y_mult
		offset += this_offset
		
#		print(this_offset)

		one_shot.subtract_time(delta)
		if one_shot.is_expired():
			one_shots.erase(one_shot)

	offset = lerp(offset, Vector3.ZERO, delta * 8)

func start_one_shot(time : float, strength_mult : float, x_mult : float = 1.0, y_mult : float = 1.0):
	var one_shot = OneShot.new(time, strength_mult, x_mult, y_mult)
	one_shots.append(one_shot)
	emit_signal("started_shaking")

func start_indefinite(strength_mult : float):
	amplitude += base_strength * strength_mult
	is_shaking_indefinitely = true
	
func end_shake():
	if !is_shaking():
		return
		
	if is_instance_valid(timer) and timer.is_connected("timeout",Callable(self,"on_timer_timeout")):
		timer.disconnect("timeout",Callable(self,"on_timer_timeout"))
	offset = Vector3.ZERO
	amplitude = 0
	await get_tree().process_frame
	is_shaking_indefinitely = false
#	set_value()

func is_shaking():
	return one_shots.size() > 0 or is_shaking_indefinitely

func on_timer_timeout():
	end_shake()

func get_noise_vector():
	var x = noise.get_noise_1d(1 * noise_y)
	var y = noise.get_noise_1d(2 * noise_y)
	var z = noise.get_noise_1d(3 * noise_y)
	return Vector3(x, y, z)
