extends CharacterBody3D

const SPEED = 25.0
const JUMP_VELOCITY = 4.5

@export var collided_particle_scene : PackedScene

func _ready() -> void:
	await get_tree().create_timer(5, false).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var vel = transform.basis.z * SPEED
	velocity = vel

#	move_and_slide()
	var coll = move_and_collide(vel * delta)
	if coll:
		on_collided(coll)

func on_collided(coll : KinematicCollision3D):
	if coll.get_collider().has_method("on_collided"):
		coll.get_collider().on_collided()
	
	var particles = collided_particle_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.emitting = true
	particles.global_position = global_position
	particles.basis = Quaternion.from_euler(Vector3(0, global_rotation.y + PI, 0))
	
	queue_free()
