extends Node3D

@export var destroy_delay : float = 0.5

func _ready() -> void:
	await get_tree().create_timer(destroy_delay, false).timeout
	queue_free()


func _process(delta: float) -> void:
	pass
