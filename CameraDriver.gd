extends Node3D

@export var follow_target : Node3D
@export var follow_speed : float = 8

func _ready() -> void:
	Global.camera_shake = $Shake


func _process(delta: float) -> void:
	global_position = lerp(global_position, follow_target.global_position, delta * follow_speed)
	$Camera3D.h_offset = $Shake.offset.x
	$Camera3D.v_offset = $Shake.offset.y
