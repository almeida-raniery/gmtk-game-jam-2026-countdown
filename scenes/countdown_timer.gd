extends Node

signal countdown_started(initial_value: int)
signal countdown_updated(value: int)
signal countdown_ended

@export var countdown_start: int

var countdown_count: int

func start_countdown():
	countdown_started.emit(countdown_start)
	countdown_count = countdown_start
	get_tree().create_timer(1).timeout.connect(update_countdown)

func update_countdown():
	if countdown_count > 0:
		countdown_count -= 1
		countdown_updated.emit(countdown_count)
		get_tree().create_timer(1).timeout.connect(update_countdown)
	else:
		countdown_ended.emit()
