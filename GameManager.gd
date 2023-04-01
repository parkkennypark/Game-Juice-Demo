extends Node3D
class_name JuiceMaster

@export var normal_shader : Shader
@export var toon_shader : Shader


var juice_master_scene : PackedScene = preload("res://JuiceMasterWindow.tscn")

var juices : Dictionary

var materials : Array

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	Global.juice_master = self

func _ready() -> void:
	get_viewport().set_embedding_subwindows(false)
	Global.spawn_packed_scene(juice_master_scene, get_tree().root, true)
	
	find_materials()
	

func find_materials(node = self):
	if node is MeshInstance3D:
		for i in range(node.get_surface_override_material_count()): 
			var mat = node.get_surface_override_material(i)
			if mat:
				materials.append(mat)
		
	for child in node.get_children():
		find_materials(child)
	
func get_toggle(option):
	if juices.has(option):
		return juices[option]
	
	printerr("No option: ", option)
	return false
	
func set_toggle(option, value):
	juices[option] = value
	
	if option == "colors":
		RenderingServer.global_shader_parameter_set("enable_color", value)
	if option == "light":
		var source = Environment.AMBIENT_SOURCE_COLOR if value else Environment.AMBIENT_SOURCE_SKY
		$WorldEnvironment.environment.ambient_light_source = source
	if option == "toon":
#		RenderingServer.global_shader_parameter_set("toon", value)
		for material in materials:
			material.shader = toon_shader if value else normal_shader
	if option == "outlines":
		$Camera/Camera3D.depth_outline_scale = 8 if value else 0 
	if option == "wiggle":
		RenderingServer.global_shader_parameter_set("wiggle", value)
	
	if option == "ui_design":
		$GameCanvasBest.visible = value
		$GameCanvasBasic.visible = !value
	
	if option == "bloom":
		$WorldEnvironment.environment.glow_enabled = value
	if option == "ambient_occlusion":
		$WorldEnvironment.environment.ssao_enabled = value
	if option == "high_contrast":
		$WorldEnvironment.environment.adjustment_enabled = value
	if option == "fog":
		$WorldEnvironment.environment.volumetric_fog_enabled = value
	
	if option == "muzzle_flash":
		$Player/Model/MuzzleFlash/OmniLight3D.visible = value
	
		
#	refresh_juice()
#	refresh_game()


func refresh_juice():
	var toon = juices["toon"]
	var outlines = juices["outlines"]
	
	print(outlines)
	$Camera/Camera3D.depth_outline_scale = 8 if outlines else 0 
