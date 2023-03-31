extends CheckButton

@export var option_name : String

func _ready() -> void:
	toggled.connect(Callable(self, "on_toggled"))

func on_toggled(pressed):
	Global.juice_master.set_toggle(option_name, pressed)
	pass
