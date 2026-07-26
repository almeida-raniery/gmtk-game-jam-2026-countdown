extends Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export_flags_3d_physics var mouse_layer_mask: int

var draggingCollider: MoveableBody
var mousePosition: Vector3
var doDrag = false

func _input(event: InputEvent):
	var intersect: Dictionary
	
	if event is InputEventMouse:
		intersect = get_mouse_intersect(event.position)
		if intersect: mousePosition = Vector3(intersect.position.x, 0.1, intersect.position.z)
		#snap on collider
		#if intersect: mousePosition = intersect.collider.global_position
		
	if event is InputEventMouseButton:
		var leftButtonPressed: bool = event.button_index == MOUSE_BUTTON_LEFT && event.pressed
		var leftButtonReleased: bool = event.button_index == MOUSE_BUTTON_LEFT && !event.pressed
		
		if leftButtonReleased:
			doDrag = false
			drag_and_drop(intersect)
		elif leftButtonPressed:
			doDrag = true
			drag_and_drop(intersect)

func _physics_process(delta: float) -> void:
	if draggingCollider:
		draggingCollider.global_position = mousePosition.clamp(Vector3(-5, 0, -4), Vector3(5, 1, 4))

func drag_and_drop(intersect: Dictionary):
	if intersect.is_empty():
		return
	
	var canMove = intersect.collider in get_tree().get_nodes_in_group("moveable")
	
	if !draggingCollider && doDrag && canMove:
		draggingCollider = intersect.collider
		draggingCollider.is_dragging = true
	elif draggingCollider:
		draggingCollider.is_dragging = false
		draggingCollider = null

	
func get_mouse_intersect(mousePosition: Vector2) -> Dictionary:
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 1000)
	params.collision_mask = mouse_layer_mask
	if draggingCollider: params.exclude = [draggingCollider]
	
	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)
	
	return result
