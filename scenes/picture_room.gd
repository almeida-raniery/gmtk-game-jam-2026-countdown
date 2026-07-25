extends Node3D

const PICTURE_ROOT_PATH = "user://pictures"

signal picture_compared(score: PictureScoreInfo)

@export var camera_subviewport: SubViewport
@export var picture_score_data: PictureScoreResource

var moveables: Dictionary[String, MoveableBody] = {}

func _ready() -> void:
	for moveable in get_tree().get_nodes_in_group("moveable"):
		moveables[moveable.name] = moveable as MoveableBody

func _on_camera_shoot():
	var picture_score := calculate_picture_score()
	save_picture_data()
	
	picture_compared.emit(picture_score)

func get_recursive_file_path(file_name: String, extension: String = "", index: int = 0) -> String:
	var next_file_name: String
	
	if index == 0:
		next_file_name = file_name + extension
	else:
		next_file_name = file_name + "_" + str(index) + extension
	
	#print (next_file_name)
	
	while FileAccess.file_exists(next_file_name):
		return get_recursive_file_path(file_name, extension, index + 1)
	
	return next_file_name

func get_recursive_dir_path(dir_name: String, index: int = 0) -> String:
	var next_dir_name
	
	if index == 0:
		next_dir_name = dir_name
	else:
		next_dir_name = dir_name + "_" + str(index)
	
	#print (next_dir_name)
	
	while DirAccess.dir_exists_absolute(next_dir_name):
		return get_recursive_dir_path(dir_name, index + 1)
	
	return next_dir_name

func save_picture_data():
	#var picture_data: Dictionary = {}
	#var moveable_position_data: Array[Dictionary] = []
	var data_dir_path := get_recursive_dir_path(PICTURE_ROOT_PATH + "/picture")
	var image_path := get_recursive_file_path(data_dir_path + "/image", ".png")
	#var picture_data_path := get_recursive_file_path(data_dir_path + "/picture_data", ".json")
	#var data_file: FileAccess
	
	if not DirAccess.dir_exists_absolute(data_dir_path):
		DirAccess.make_dir_recursive_absolute(data_dir_path)
	#
	#for moveable in moveables.values():
		#if moveable is MoveableBody:
			#var moveable_data: Dictionary[String, String] = {}
			#
			#moveable_data["rid"] = str(moveable.get_rid())
			#moveable_data["x"] = str(moveable.position.x)
			#moveable_data["y"] = str(moveable.position.y)
			#moveable_data["z"] = str(moveable.position.z)
			#
			#moveable_position_data.append(moveable_data)
	##
	#picture_data["image_path"] = image_path
	#picture_data["positions"] = moveable_position_data
	#
	#data_file = FileAccess.open(picture_data_path, FileAccess.WRITE)
	#
	#data_file.store_line(JSON.stringify(picture_data))
	#data_file.close()
	
	camera_subviewport.get_texture().get_image().save_png(image_path)

func calculate_picture_score() -> PictureScoreInfo:
	var reference_image := picture_score_data.reference_texture.get_image()
	var metrics := reference_image.compute_image_metrics(camera_subviewport.get_texture().get_image(), true)
	var success := metrics["mean"] as float <= picture_score_data.difference_margin
	var character_proximities: Dictionary[CharacterScoreResource, float]
	
	print(metrics["mean"])
	
	for character_name: String in picture_score_data.character_scores.keys():
		var character_score := picture_score_data.character_scores[character_name]
		var character := moveables[character_name]
		
		success = success and character_score.pose == character.pose
		character_proximities[character_score] = abs(character_score.pos.x - character.position.x)
	
	var info := PictureScoreInfo.new(1 - metrics["mean"], success,character_proximities )
	
	return info
