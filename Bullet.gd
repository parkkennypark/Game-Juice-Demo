extends CharacterBody3D

const SPEED = 25.0
const JUMP_VELOCITY = 4.5

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
		
	queue_free()
