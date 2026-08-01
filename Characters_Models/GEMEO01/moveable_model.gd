class_name MoveableModel extends Node3D

enum AnimationState {IDLE, PICKED, REACTION_L, REACTION_R}

@export var default_animation_state: AnimationState
@export var state_animations: Dictionary[AnimationState, String]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play(state_animations[default_animation_state])

func play_animation(state: AnimationState):
	animation_player.play(state_animations[state])
