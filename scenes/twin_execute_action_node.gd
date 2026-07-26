extends Node

@export var fighting_cloud: Node3D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var nearby_twin: MoveableBody

func _on_action_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("twin"):
		nearby_twin = body

func _on_action_area_body_exited(body: Node3D) -> void:
	if body == nearby_twin:
		nearby_twin = null

func _on_countdown_timer_countdown_ended() -> void:
	var parent_body: MoveableBody = get_parent()
	
	if nearby_twin:
		nearby_twin.visible = false
		parent_body.visible = false
		parent_body.pose = CharacterScoreResource.CharacterPose.ACTION
		nearby_twin.pose = CharacterScoreResource.CharacterPose.ACTION
		fighting_cloud.position.x = nearby_twin.position.x + parent_body.position.x
		fighting_cloud.position.z = nearby_twin.position.z + parent_body.position.z
		fighting_cloud.visible = true
		audio_player.play()
