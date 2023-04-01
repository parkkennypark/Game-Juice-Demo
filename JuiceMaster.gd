extends Window

signal something_changed

var options : Dictionary

#func _ready() -> void:
#	Global.set_juice_master(self)

func refresh_game():
	something_changed.emit()

func set_toggle(option, value):
	options[option] = value
	
	if option == "colors":
		ProjectSettings.set("shader_globals/enable_color", value)
	if option == "wiggle":
		ProjectSettings.set("shader_globals/wiggle", value)
	
	refresh_game()

func get_toggle(option):
	if options.has(option):
		return options[option]
	
	printerr("No option: ", option)
	return false
