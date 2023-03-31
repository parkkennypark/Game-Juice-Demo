extends Window
class_name JuiceMaster

signal something_changed

var options : Dictionary

func _ready() -> void:
	Global.juice_master = self

func refresh_game():
	something_changed.emit()

func set_toggle(option, value):
	options[option] = value
	
	
	if option == "colors":
		ProjectSettings.set("shader_globals/enable_color", value)
	if option == "wiggle":
		ProjectSettings.set("shader_globals/wiggle", value)
	
	print(ProjectSettings.get("shader_globals/wiggle"))
	
