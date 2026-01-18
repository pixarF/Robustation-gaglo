class_name MoveToPlayerComponent extends BaseMobBehaviorComponent

@onready var player: CharacterBody2D = scene.get_node_or_null("Player")
@onready var move_to_point_component: MoveToPointComponent = get_parent().get_node_or_null("MoveToPointComponent")

@export var priority: int = 1

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if player == null or move_to_point_component == null:
		return
	
	move_to_point_component.set_point(player.global_position, priority)
