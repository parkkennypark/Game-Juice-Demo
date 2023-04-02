extends CheckButton

@export var option_name : String
@export var dont_batch_toggle : bool

func _ready() -> void:
	toggled.connect(Callable(self, "on_toggled"))
	on_toggled(false)
	
	if !dont_batch_toggle:
		owner.batch_toggle.connect(Callable(self, "on_toggled"))


func on_toggled(pressed):
	Global.juice_master.set_toggle(option_name, pressed)
