extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var projectile_scene : PackedScene
@export var fire_particles_scene : PackedScene
@export var muzzle_flash_animation_player : AnimationPlayer

@onready var camera = get_viewport().get_camera_3d()

func _process(delta: float) -> void:
#	$PointerPosition.global_position = get_mouse_pos()
	var vec_to_pointer = get_mouse_pos() - global_position
	vec_to_pointer.y = 0
	
	var angle = global_transform.basis.z.signed_angle_to(vec_to_pointer.normalized(), Vector3.UP)
	
	var dist = vec_to_pointer.length()
	$Pointer.rotation.y = angle
	$Pointer/Position.position.z = dist
	$Pointer/Rotation.scale.z = dist
	$Pointer/Rotation/Geometry.material_override.uv1_scale = Vector3.ONE * dist * 2
	
	var player_angle = Vector3.BACK.signed_angle_to(vec_to_pointer.normalized(), Vector3.UP)
	var target_rot = Quaternion.from_euler(Vector3(0, player_angle, 0))
	global_transform.basis = global_transform.basis.slerp(target_rot, delta * 5)
#	$Model.global_transform.basis = $Model.global_transform.basis.slerp(target_rot, delta * 5)
	
	if Input.is_action_just_pressed("fire"):
		fire_projectile()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var relative_dir = input_dir.rotated(-camera.rotation.y)
	var direction := (transform.basis * Vector3(relative_dir.x, 0, relative_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func get_mouse_pos() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	
	if direction.y == 0:
		return Vector3.ZERO

	var distance = -origin.y/direction.y
	var position = origin + direction * distance
	return position


func fire_projectile():
	$Model/AnimationPlayer.play("Fire")
	$Model/AnimationPlayer.seek(0, false)
	
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = global_position + Vector3.UP * 0.5
	projectile.global_rotation = $Model.global_rotation
	
	var particles = fire_particles_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.emitting = true
	particles.global_position = $Model/MuzzleFlash.global_position
	particles.global_rotation = $Model.global_rotation
	
	flash_muzzle()

func flash_muzzle():
	muzzle_flash_animation_player.play("Flash")
	muzzle_flash_animation_player.seek(0, true)
	
