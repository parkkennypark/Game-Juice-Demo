extends Node

var camera_shake : Shake
var gui

var player
var juice_master : JuiceMaster

var duck_scene : PackedScene = preload("res://duck_game/DuckGuy.tscn")
var duck_multiply_particles_scene : PackedScene = preload("res://FireParticles.tscn")

var juice_master_scene : PackedScene = preload("res://JuiceMasterWindow.tscn")


func _ready() -> void:
	get_viewport().set_embedding_subwindows(false)
	spawn_packed_scene(juice_master_scene, get_tree().root, true)
	pass

func spawn_packed_scene(packedScene, parent : Node = get_tree().root, deferred = false) -> Node:
	if packedScene == null:
		printerr("Tried to spawn a null scene.")
		return null

	if !is_instance_valid(parent):
		printerr("Tried to spawn object to null parent.")
		return null

	var instance = packedScene.instantiate()
	if deferred:
		parent.call_deferred("add_child", instance)
	else:
		parent.add_child(instance)
	return instance

func get_random_pos_in_sphere () -> Vector3:
	var x1 = randf_range(-1, 1)
	var x2 = randf_range (-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = randf_range (-1, 1)
		x2 = randf_range (-1, 1)

	var random_pos_on_unit_sphere = Vector3 (
	2 * x1 * sqrt (1 - x1*x1 - x2*x2),
	2 * x2 * sqrt (1 - x1*x1 - x2*x2),
	1 - 2 * (x1*x1 + x2*x2))

	return random_pos_on_unit_sphere
