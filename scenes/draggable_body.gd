class_name MoveableBody extends CharacterBody3D

const SPEED = 30

@export var pose: CharacterScoreResource.CharacterPose

var is_dragging: bool

func _physics_process(delta: float) -> void:	
	if not is_on_floor() and not is_dragging:
		velocity += get_gravity() * delta
	
	velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	velocity.z = move_toward(velocity.z, 0, SPEED * delta)
	
	move_and_slide()
