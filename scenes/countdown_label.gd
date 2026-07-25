extends Label

func _on_node_countdown_started(initial_value: int) -> void:
	text = str(initial_value)
	visible = true

func _on_countdown_timer_countdown_updated(value: int) -> void:
	text = str(value)
