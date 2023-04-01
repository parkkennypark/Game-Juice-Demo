extends StaticBody3D

@export var health : int = 3
@export var damaged_particle_scene : PackedScene

signal destroyed


func _ready() -> void:
	$Target.material_overlay = $Target.material_overlay.duplicate()


func on_collided():
	if Global.juice_master.get_toggle("shake"):
		Global.camera_shake.start_one_shot(0.2, 1)
	
	if Global.juice_master.get_toggle("animations"):
		$AnimationPlayer.play("Hit")
		$AnimationPlayer.seek(0, true)
	
	if Global.juice_master.get_toggle("particles"):
		var particles = damaged_particle_scene.instantiate()
		get_tree().root.add_child(particles)
		particles.global_position = global_position + Global.get_random_pos_in_sphere()
	
	health -= 1
	
	if health <= 0:
		destroy()

func destroy():
	if Global.juice_master.get_toggle("shake"):
		Global.camera_shake.start_one_shot(0.5, 2)
	
	remove_from_group("Target")
	destroyed.emit()
	queue_free()
