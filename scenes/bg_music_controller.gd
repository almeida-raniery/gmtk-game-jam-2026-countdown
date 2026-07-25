extends Node

@export var music_player_map: Dictionary[String, AudioStreamPlayer]

var current_song_key: String = "gameplay"

func play_song(song_key: String):
	music_player_map[current_song_key].stop()
	current_song_key = song_key
	music_player_map[song_key].play()
