class_name PlayerCamera extends Camera2D

@export var offset_modifier: int = 15
@onready var parent = get_parent()
@onready var direction_component = get_direction_component()

func _notification(notif):
	if notif == NOTIFICATION_PARENTED:
		parent = get_parent()
		direction_component = get_direction_component()

func get_direction_component():
	return parent.get_node("DirectionComponent")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	_set_camera_offset()
	_look_at_cursor()

func _set_camera_offset():
	var _mouse_position = get_global_mouse_position()
	var _mouse_offset = _mouse_position - parent.global_position
	
	var _normalized_offset = Vector2(
		_mouse_offset.x / (offset_modifier),
		_mouse_offset.y / (offset_modifier))
	
	offset = _normalized_offset

func _look_at_cursor():
	if not parent.has_node("DirectionComponent"):
		return
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	direction_component.look_at_direction(direction)
