extends Node

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal action_played

func _on_action_area_body_entered(body: Node3D) -> void:
	var cat_body := get_parent() as MoveableBody
	
	if body.is_in_group("PlayerCharacter"):
		cat_body.velocity += (cat_body.position - body.position).normalized() * 12
		cat_body.velocity.y = 2.5
		audio_player.play()
		cat_body.pose = CharacterScoreResource.CharacterPose.ACTION
	
	action_played.emit()
