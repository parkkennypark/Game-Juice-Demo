extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var food_eaten : int = 1

var names = [
"Henry", 
"Quackter", 
"Quackinsworth", 
"Drake the Quacker", 
"George Quackahashi", 
"Quacker Oats", 
"Quackitha",
"Quacktillion",
"Quackton Tarantino",
"Quaxalot",
"Qwack",
"Carl",
"Michellin",
"Goose"
]

var colors = [
	Color.AQUAMARINE,
	Color.CORNFLOWER_BLUE,
	Color.CORAL,
	Color.DEEP_PINK,
	Color.LIGHT_GREEN,
]

@onready var animation_player : AnimationPlayer = $Model/AnimationPlayer
@onready var level_label : Label3D = $Label3D2

func _ready() -> void:
	$Label3D.text = names.pick_random()
	
#	scale.x *= randf_range(0.9, 5)
	scale_object_local(Vector3(randf_range(0.9, 3), 1, 1))
	
	enable_random_hat()
	randomize_color()

func randomize_color():
	$Model/Z_Rot/Model.material_override = $Model/Z_Rot/Model.material_override.duplicate()
	var color = colors.pick_random()
	color = lerp(color, Color.WHITE, 0.5)
	$Model/Z_Rot/Model.material_override.albedo_color = color
	

func enable_random_hat():
	var hats = []
	for child in $Model/Z_Rot/Model/Hats.get_children():
		child.visible = false
		hats.append(child)
	
	hats.pick_random().visible = true
	


func get_closest_food():
	var closest_food : Node3D = null
	var closest_dist : float
	for food in get_tree().get_nodes_in_group("Food"):
		var dist = food.global_position.distance_to(global_position)
		if dist < closest_dist or closest_food == null:
			closest_food = food
			closest_dist = dist
	
	return closest_food
	
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var food : Node3D = get_closest_food()
	
	var input_dir = Global.player.global_position - global_position
	
	if food != null:
		input_dir = food.global_position - global_position
		input_dir.y = 0
	
	else:
		# Stop duck 
		var dist_to_player = global_position.distance_to(Global.player.global_position)
		if dist_to_player < 1:
			input_dir = Vector3.ZERO
	
	input_dir = input_dir.normalized()
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	animation_player.speed_scale = 1 if velocity.length() > 1 else 0
	
	if is_instance_valid(food):
		# Eat food
		var dist = global_position.distance_to(food.global_position)
		if dist < 1:
			animation_player.play("eat")
			food.queue_free()
			level_up()
		
	# Rotate to food
	var angle = Vector3.FORWARD.signed_angle_to(input_dir, Vector3.UP)
	var target_rot = Quaternion.from_euler(Vector3(0, angle + PI, 0))
#	$Model/Z_Rot/Model.global_transform.basis = $Model.global_transform.basis.slerp(target_rot, delta * 8) .orthonormalized()
	$Model/Z_Rot/Model.rotation.y = angle + PI
#	$Model/Z_Rot/Model.look_at(food.global_position if food else Global.player.global_position)

	move_and_slide()

func level_up():
#	%PostProcessingAnimation.play("blammo")
#	%PostProcessingAnimation.seek(0, true)
	
	food_eaten += 1
	level_label.text = "(level " + str(food_eaten) + ")"
	scale += Vector3.ONE * 0.1
	
	if food_eaten >= 5:
		print("TWO DUCK")
		for i in range(2):
			var duck = Global.duck_scene.instantiate()
			get_tree().root.add_child(duck)
			duck.global_position = global_position + Vector3.RIGHT * i

		queue_free()
		
