class_name PictureScoreInfo extends RefCounted

var accuracy: float
var success: bool
var character_proximity: Dictionary[CharacterScoreResource, float]

func _init(_accuracy: float, _success: bool, _character_proximity: Dictionary[CharacterScoreResource, float]) -> void:
	accuracy = _accuracy
	success = _success
	character_proximity = _character_proximity
