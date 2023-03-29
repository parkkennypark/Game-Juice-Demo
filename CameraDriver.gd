extends Node3D

@export var follow_target : Node3D
@export var follow_speed : float = 8

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	global_position = lerp(global_position, follow_target.global_position, delta * follow_speed)
