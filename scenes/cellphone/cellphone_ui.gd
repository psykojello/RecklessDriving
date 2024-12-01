extends Area3D

@onready var sprite3d: Sprite3D = $Sprite3D
@onready var viewport:SubViewport = $Sprite3D/SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_input_event(camera: Node, event: InputEvent, pos: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	var texture_3d_position = sprite3d.get_global_transform().affine_inverse() * pos
	
	## Position of the event relative to the texture.
	var texture_position: Vector2 = Vector2(texture_3d_position.x, -texture_3d_position.y) / sprite3d.pixel_size - sprite3d.get_item_rect().position
	# Send mouse event.
	var e: InputEvent = event.duplicate()
	if e is InputEventMouse:
		e.set_position(texture_position)
		e.set_global_position(texture_position)
		viewport.push_input(e)


func _on_mouse_entered() -> void:
	print("Mouse entered")
