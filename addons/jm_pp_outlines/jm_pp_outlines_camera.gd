@tool
extends Camera3D

var screen_mesh : MeshInstance3D;

var global_post_process_material : ShaderMaterial = preload("post_process_outlines_material.tres");
var instance_post_process_material : ShaderMaterial = global_post_process_material.duplicate();

#Size of color outlines
@export var color_outline_scale : float = 0.0 : get = get_color_scale, set = set_color_scale

#Size of depth outlines
@export var depth_outline_scale : float = 5.0 : get = get_depth_scale, set = set_depth_scale

#Controls sensitivity to depth changes (lower values mean more outlines, but more artifacts too)
@export_range(0, 10) var depth_threshold : float = 10.0 : get = get_depth_thres, set = set_depth_thres

#Multiplier for depth values
@export var depth_multiplier : float = 1000.0 : get = get_depth_multiplier, set = set_depth_multiplier

#General threshold for values to be considered as edges
@export_range(0, 1) var edge_threshold : float = 0.05 : get = get_edge_threshold, set = set_edge_threshold

#Max edge alpha, lower values means edges blend more with background
@export_range(0, 1) var max_edge_alpha : float = 0.8 : get = get_max_edge_alpha, set = set_max_edge_alpha

#General multiplier for edge alpha value, higher values mean harder edges
@export var edge_alpha_multiplier : float = 3.0 : get = get_alpha_multiplier, set = set_alpha_multiplier

#Outlines color
@export var edge_color : Color = Color(0,0,0,1) : get = get_edge_color, set = set_edge_color

#Sets depth edges to use the laplace operator instead of sobel
@export var background_tex : Texture2D : get = get_bg_tex, set = set_bg_tex

#Sets depth edges to use the laplace operator instead of sobel
@export var depth_use_laplace : bool = true : get = get_depth_use_laplace, set = set_depth_use_laplace

#Sets color edges to use the laplace operator instead of sobel
@export var color_use_laplace : bool = false : get = get_color_use_laplace, set = set_color_use_laplace

#Sets shader to use render the BG behind the edges
@export var use_bg_texture : bool = false : get = get_use_bg_texture, set = set_use_bg_texture

func set_color_scale(value):
	color_outline_scale = value;
	instance_post_process_material.set_shader_parameter("color_outline_scale", value);

func get_color_scale():
	return color_outline_scale;

func set_depth_scale(value):
	depth_outline_scale = value;
	instance_post_process_material.set_shader_parameter("depth_outline_scale", value);

func get_depth_scale():
	return depth_outline_scale;

func set_depth_thres(value):
	depth_threshold = value;
	instance_post_process_material.set_shader_parameter("depth_threshold", value);

func get_depth_thres():
	return depth_threshold;

func set_depth_multiplier(value):
	depth_multiplier = value;
	instance_post_process_material.set_shader_parameter("depth_multiplier", value);

func get_depth_multiplier():
	return depth_multiplier;

func set_edge_threshold(value):
	edge_threshold = value;
	instance_post_process_material.set_shader_parameter("edge_threshold", value);

func get_edge_threshold():
	return edge_threshold;

func set_max_edge_alpha(value):
	max_edge_alpha = value;
	instance_post_process_material.set_shader_parameter("max_edge_alpha", value);

func get_max_edge_alpha():
	return max_edge_alpha;

func set_alpha_multiplier(value):
	edge_alpha_multiplier = value;
	instance_post_process_material.set_shader_parameter("edge_alpha_multiplier", value);

func get_alpha_multiplier():
	return edge_alpha_multiplier;

func set_edge_color(value):
	edge_color = value;
	instance_post_process_material.set_shader_parameter("edge_color", value);

func get_edge_color():
	return edge_color;

func set_bg_tex(value):
	background_tex = value;
	instance_post_process_material.set_shader_parameter("bgTex", value);

func get_bg_tex():
	return background_tex;

func set_depth_use_laplace(value):
	depth_use_laplace = value;
	instance_post_process_material.set_shader_parameter("depth_use_laplace", value);

func get_depth_use_laplace():
	return depth_use_laplace;

func set_color_use_laplace(value):
	color_use_laplace = value;
	instance_post_process_material.set_shader_parameter("color_use_laplace", value);

func get_color_use_laplace():
	return color_use_laplace;

func set_use_bg_texture(value):
	use_bg_texture = value;
	instance_post_process_material.set_shader_parameter("use_bg_texture", value);

func get_use_bg_texture():
	return use_bg_texture;

func _ready():
	screen_mesh = MeshInstance3D.new();
	var quad : QuadMesh = QuadMesh.new();
	quad.size = Vector2(2,2);
	screen_mesh.mesh = quad;
	screen_mesh.material_override = instance_post_process_material;
	screen_mesh.extra_cull_margin = 16000;
	add_child(screen_mesh);
	
	set_color_scale(color_outline_scale)
	set_depth_scale(depth_outline_scale)
	set_alpha_multiplier(edge_alpha_multiplier)
	set_depth_thres(depth_threshold)
	set_depth_multiplier(depth_multiplier)
	set_edge_threshold(edge_threshold)
	set_max_edge_alpha(max_edge_alpha)
	set_edge_color(edge_color)
	set_bg_tex(background_tex)
	set_use_bg_texture(use_bg_texture)
	set_depth_use_laplace(depth_use_laplace)
	set_color_use_laplace(color_use_laplace)
	
	print("Camera outlines setup.")
