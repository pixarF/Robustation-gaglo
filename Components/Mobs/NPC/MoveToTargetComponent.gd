class_name MoveToTargetComponent extends BaseMobBehaviorComponent

@export var set_player_as_target: bool = true

@onready var target: CharacterBody2D
@onready var move_to_point_component: MoveToPointComponent = get_parent().get_node_or_null("MoveToPointComponent")

@export var priority: int = 1

func _ready() -> void:
	super._ready()
	target = scene.get_node_or_null("Player")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if target == null or move_to_point_component == null:
		return
	
	move_to_point_component.set_point(target.global_position, priority)
