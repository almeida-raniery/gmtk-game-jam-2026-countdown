extends Control

@onready var succes_icon: Control = $Success
@onready var failure_icon: Control = $Failure

func _on_main_picture_compared(info: PictureScoreInfo) -> void:
	var character_labels: Array[Label]
	
	succes_icon.visible = info.success
	failure_icon.visible = !info.success
	
	for character_resource: CharacterScoreResource in info.character_proximity.keys():
		var proximity = info.character_proximity[character_resource]
		var label := Label.new()
		
		label.text = str(1000/character_resource.pos.x * proximity)
	
	await get_tree().create_timer(0.8).timeout
	
	succes_icon.visible = false
	failure_icon.visible = false
