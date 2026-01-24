class_name MoveToPointComponent extends BaseMobBehaviorComponent

@export var navigation_agent: NavigationAgent2D
@export var point: Vector2
@export var curret_priority: int = -1
@export var stop_range: int = 48
@export var update_rate: float = 0.1
@onready var mob_mover_component: MobMoverComponent = parent.get_node_or_null("MobMoverComponent")
@onready var direction_component: DirectionComponent = parent.get_node_or_null("DirectionComponent")
var pathfinding_timer: Timer

@export var run_to_target_range: float = 130
@export var run_from_target_range: float = 250
@export var look_at_direction: bool = false

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
	
	var direction_to_target = (point - parent.global_position)
	var distance_to_target = direction_to_target.length()
	
	if distance_to_target > run_from_target_range:
		mob_mover_component.direction = direction_to_target.normalized()
	elif distance_to_target < run_to_target_range:
		var away_direction = -direction_to_target.normalized()
		mob_mover_component.direction = away_direction
		_set_direction()
		return
	else:
		mob_mover_component.direction = Vector2.ZERO
		return
	
	if navigation_agent.is_navigation_finished() or distance_to_target < stop_range:
		if mob_mover_component.direction != Vector2.ZERO:
			mob_mover_component.direction = Vector2.ZERO
			curret_priority = -1
			point = Vector2.ZERO
		return
	
	mob_mover_component.direction = parent.global_position.direction_to(navigation_agent.get_next_path_position())
	_set_direction()

func _keep_distance():
	var direction_from_target = (parent.global_position - point).normalized()
	
	var spread = deg_to_rad(randf_range(-30, 30))
	var escape_direction = direction_from_target.rotated(spread)
	
	return escape_direction

func _set_direction():
	if direction_component == null or look_at_direction == false:
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
