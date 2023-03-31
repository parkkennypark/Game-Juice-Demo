extends CanvasLayer

signal scene_changed

var changing : bool
var current_game_area

@onready var transition = $Diamonds


func go_to_scene(path, currentRoot):
	if changing:
		return

	print("Changing to path ", path)

	if path.is_empty():
		print("No path ", path)
		return

	changing = true

	# switch to loading screen
	transition.close()

#	BgmManager._fade_out()

	await get_tree().create_timer(3).timeout

	var scene = load(path)
	if scene == null:
		return

	currentRoot.queue_free()

	Global.spawn_packed_scene(scene)
	await get_tree().process_frame

#	emit_signal("entered_game_area", game_area)
	emit_signal("scene_changed")

#	await get_tree().create_timer(1).timeout

	transition.open()
	
	#BgmManager.change_cycle(Soundtrack.CYCLES.World_Tree)
	# if a new cycle is necessary:
#	BgmManager.request_cycle_start()

	await get_tree().create_timer(1).timeout

	changing = false

