class_name MoveableBody extends CharacterBody3D

var is_dragging: bool


func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dragging:
		velocity += get_gravity() * delta
	
	move_and_slide()
