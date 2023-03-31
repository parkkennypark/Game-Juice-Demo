extends Control
class_name TransitionUI

signal closed

@export var open_sound: AudioStream
@export var close_sound: AudioStream

@onready var diamonds = self
@onready var transitionMaterial : Material = diamonds.material

func _ready() -> void:
	transitionMaterial.set("shader_parameter/progress", 0.0)

func close():
	var tween : Tween = create_tween()
	tween.tween_property(transitionMaterial, "shader_parameter/progress", 1.0, 1.0)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.play()

#	SfxManager.play(0, self, close_sound, -8, 0.65)
	await tween.finished
	emit_signal("closed")


func open():
	var tween : Tween = create_tween()
	tween.tween_property(transitionMaterial, "shader_parameter/progress", 0.0, 1.0)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.play()

#	SfxManager.play(0, self, close_sound, -8, 0.65)
	await tween.finished
