extends CanvasLayer

@onready var targets_left_label : Label = $TargetsLeftLabel


func _ready() -> void:
	for target in get_tree().get_nodes_in_group("Target"):
		target.destroyed.connect(Callable(self, "on_target_destroyed"))
	
	update_target_left_label()
	


func _process(delta: float) -> void:
	pass

func get_targets_left():
	return get_tree().get_nodes_in_group("Target").size()

func on_target_destroyed():
	update_target_left_label()
	if get_targets_left() == 0:
		SceneChanger.go_to_scene("res://Juiced.tscn", owner)

func update_target_left_label():
	var targets_left = get_targets_left()
	targets_left_label.text = str(targets_left)
	$TargetsLeftLabel/AnimationPlayer.play("Update")
	$TargetsLeftLabel/AnimationPlayer.seek(0, false)
	
