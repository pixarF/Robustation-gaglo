class_name DirectionalSprite extends Sprite2D

var parent = get_parent()
@onready var direction_component : DirectionComponent = get_direction_component()

func _notification(notif):
	if notif == NOTIFICATION_PARENTED:
		parent = get_parent()
		direction_component = get_direction_component()

func get_direction_component():
	if parent.has_node("DirectionComponent"):
		return parent.get_node("DirectionComponent")
	else:
		return null

func _ready() -> void:
	if direction_component != null:
		direction_component.direction_changed.connect(change_sprite_direction)

func change_sprite_direction(rect: Rect2):
	region_rect = rect
