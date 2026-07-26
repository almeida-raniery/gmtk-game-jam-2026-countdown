extends Node3D

const PICTURE_ROOT_PATH = "user://pictures"
const CHARACTER_HORIZONTAL_RANGE = 0.2
const CHARACTER_POSE_MODIFIER = 120
const CHARACTER_POSITION_MODIFIER = 200
const PLAYER_ROTATION_MARGIN = 10

signal picture_compared(score: PictureScoreInfo)

@export var camera_subviewport: SubViewport
@export var picture_score_data: PictureScoreResource
@export var player_character: PlayerCharacter

var moveables: Dictionary[String, MoveableBody] = {}

func _ready() -> void:
	for moveable in get_tree().get_nodes_in_group("moveable"):
		moveables[moveable.name] = moveable as MoveableBody

func _on_camera_shoot():
	get_tree().paused = true
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
	var picture_data: Dictionary = {}
	var moveable_position_data: Array[Dictionary] = []
	var data_dir_path := get_recursive_dir_path(PICTURE_ROOT_PATH + "/picture")
	var image_path := get_recursive_file_path(data_dir_path + "/image", ".png")
	var picture_data_path := get_recursive_file_path(data_dir_path + "/picture_data", ".json")
	var data_file: FileAccess
	
	if not DirAccess.dir_exists_absolute(data_dir_path):
		DirAccess.make_dir_recursive_absolute(data_dir_path)
	
	for moveable in moveables.values():
		if moveable is MoveableBody:
			var moveable_data: Dictionary[String, String] = {}
			
			moveable_data["rid"] = str(moveable.get_rid())
			moveable_data["x"] = str(moveable.position.x)
			moveable_data["y"] = str(moveable.position.y)
			moveable_data["z"] = str(moveable.position.z)
			
			moveable_position_data.append(moveable_data)
	#
	picture_data["image_path"] = image_path
	picture_data["positions"] = moveable_position_data
	
	data_file = FileAccess.open(picture_data_path, FileAccess.WRITE)
	
	data_file.store_line(JSON.stringify(picture_data))
	data_file.close()
	
	camera_subviewport.get_texture().get_image().save_png(image_path)

func calculate_picture_score() -> PictureScoreInfo:
	var score: int = -2000
	var info := PictureScoreInfo.new()
	var camera_image = camera_subviewport.get_texture().get_image()
	var reference_image := picture_score_data.reference_texture.get_image()
	var metrics := reference_image.compute_image_metrics(camera_image, true)
	var character_scores: Dictionary[CharacterScoreResource, int]
	var player_proximity_modifier = get_character_proximity_modifier(player_character, "Player")
	
	if metrics["mean"] as float <= picture_score_data.difference_margin:
		score += 2000
		print(score)
	
	print(metrics["mean"])
	
	for character_name: String in picture_score_data.character_scores.keys():
		if not moveables.has(character_name):
			continue;
		
		var character_score := picture_score_data.character_scores[character_name]
		var character := moveables[character_name]
		var character_score_modifier = get_character_proximity_modifier(character, character_name)
		
		if character_score.pose == character.pose:
			character_score_modifier += CHARACTER_POSE_MODIFIER
		
		character_scores[character_score] = character_score_modifier
		score += character_score_modifier
	
	score += player_proximity_modifier
	
	if abs(180 - player_character.model.rotation_degrees.y) <= PLAYER_ROTATION_MARGIN:
		score += CHARACTER_POSE_MODIFIER

	
	info.result_picture = camera_subviewport.get_texture()
	info.final_score = score
	info.accuracy = clamp((picture_score_data.difference_margin - metrics["mean"])/picture_score_data.difference_margin, 0, 1)
	info.success = score >= 600
	
	return info

func get_character_proximity_modifier(character: Node3D, key: String) -> int:
	var character_score := picture_score_data.character_scores[key]
	var character_delta = abs(character_score.pos.x - character.position.x)
	var score_modifier = (1 - clamp(character_delta/CHARACTER_HORIZONTAL_RANGE, 0, 1)) * CHARACTER_POSITION_MODIFIER
	
	return score_modifier


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
