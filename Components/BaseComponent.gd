@abstract
class_name Component extends Node

@onready var scene: Node2D = get_tree().get_root().get_node("Game")
@onready var parent = get_parent()

func _notification(notif):
	if notif == NOTIFICATION_PARENTED:
		parent = get_parent()
