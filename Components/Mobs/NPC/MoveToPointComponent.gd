class_name MoveToPointComponent extends BaseMobBehaviorComponent

@export var navigation_agent: NavigationAgent2D
@export var point: Vector2
@export var curret_priority: int = -1
@export var stop_range: int = 64
@export var update_rate: float = 0.1
@onready var mob_mover_component: MobMoverComponent = parent.get_node_or_null("MobMoverComponent")
@onready var direction_component: DirectionComponent = parent.get_node_or_null("DirectionComponent")
var pathfinding_timer: Timer

func set_point(position, priority):
	if curret_priority > priority:
		return
	
	point = position

func _ready() -> void:
	super._ready()
	
	pathfinding_timer = Timer.new()
	add_child(pathfinding_timer)
	pathfinding_timer.one_shot = true
	pathfinding_timer.wait_time = update_rate
	pathfinding_timer.timeout.connect(_pathfinding_update)
	pathfinding_timer.start()
	
	if navigation_agent != null:
		navigation_agent.velocity_computed.connect(_on_navigation_agent_velocity_computed)
	if mob_mover_component == null:
		mob_mover_component = parent.get_node_or_null("MobMoverComponent")
	if direction_component == null:
		direction_component = parent.get_node_or_null("DirectionComponent")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if mob_mover_component == null or navigation_agent == null:
		return
	
	if navigation_agent.is_navigation_finished() or (point - parent.global_position).length() < stop_range:
		if mob_mover_component.direction != Vector2.ZERO:
			mob_mover_component.direction = Vector2.ZERO
			curret_priority = -1
			point = Vector2.ZERO
		return
	
	mob_mover_component.direction = parent.global_position.direction_to(navigation_agent.get_next_path_position())
	_set_direction()

func _set_direction():
	if direction_component == null:
		return
	
	var direction = (navigation_agent.get_next_path_position() - parent.global_position).normalized()
	direction_component.look_at_direction(direction)

func _pathfinding_update():
	navigation_agent.target_position = point
	
	pathfinding_timer.wait_time = randf_range(update_rate * 0.9, update_rate * 1.2)
	pathfinding_timer.start()

func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	if mob_mover_component != null:
		mob_mover_component.direction = safe_velocity
