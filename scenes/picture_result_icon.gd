extends Control

@onready var succes_icon: Control = $Success
@onready var failure_icon: Control = $Failure
@onready var success_sound: AudioStreamPlayer = $Success/AudioStreamPlayer
@onready var failure_sound: AudioStreamPlayer = $Failure/AudioStreamPlayer


func _on_main_picture_compared(info: PictureScoreInfo) -> void:
	var character_labels: Array[Label]
	
	if info.success:
		succes_icon.visible = true
		success_sound.play()
	else:
		failure_icon.visible = true
		failure_sound.play()
	
	for character_resource: CharacterScoreResource in info.character_proximity.keys():
		var proximity = info.character_proximity[character_resource]
		var label := Label.new()
		
		label.text = str(1000/character_resource.pos.x * proximity)
	
	await get_tree().create_timer(0.8).timeout
	
	succes_icon.visible = false
	failure_icon.visible = false
