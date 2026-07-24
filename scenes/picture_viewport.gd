extends SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shoot_button_pressed():
	var image := get_texture().get_image()
	
	image.save_png("user://picture.png")
