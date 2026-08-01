class_name MoveableBody extends CharacterBody3D

const SPEED = 30

signal state_changed(state: MoveableModel.AnimationState)

@export var pose: CharacterScoreResource.CharacterPose
@export var model: Node3D

var animation_player: AnimationPlayer
var is_dragging: bool

func _ready() -> void:
	animation_player = model.find_child("AnimationPlayer")

func _physics_process(delta: float) -> void:	
	if not is_on_floor() and not is_dragging:
		velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)
	
	move_and_slide()
