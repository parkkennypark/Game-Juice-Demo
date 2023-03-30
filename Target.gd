extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Target.material_overlay = $Target.material_overlay.duplicate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_collided():
	Global.camera_shake.start_one_shot(0.2, 1)
	$AnimationPlayer.play("Hit")
	$AnimationPlayer.seek(0, true)
	pass
