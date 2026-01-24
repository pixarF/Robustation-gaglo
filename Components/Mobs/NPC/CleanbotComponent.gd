class_name CleanbotComponent extends Component

var cleaning: bool = false
var target: Node2D = null

@onready var weapon_user_component: WeaponUserComponent = parent.get_node_or_null("WeaponUserComponent")
@onready var move_to_point_component: MoveToPointComponent = get_parent().get_node_or_null("MoveToPointComponent")

func _process(_delta):
	if move_to_point_component != null and target != null:
		move_to_point_component.set_point(target.global_position, 1)
	
	if cleaning == true and target != null:
		if (target.global_position - parent.global_position).length() > 48:
			return
		
		var weapon = weapon_user_component.selected_weapon
		
		if weapon == null or weapon.cooldown == true or weapon.swinging == true:
			return
		
		await weapon.attack(self)
		if target == null:
			return
		
		target.clean_health -= 1
		
		var progress = 1.0 - float(target.clean_health) / target.max_clean_health
		
		var start_color = Color(0.705, 0.029, 0.236, 1.0)
		var end_color = Color(0.0, 0.0, 1.0, 0.1)
		
		var new_color = start_color.lerp(end_color, progress)
		
		var _tween = create_tween()
		_tween.tween_property(target, "self_modulate", new_color, 0.2)
		
		if target.clean_health <= 0:
			target.queue_free()
			target = null
		return
	elif cleaning == true and target == null:
		cleaning = false
	
	var all_nodes = scene.get_children()
	var blood_pools = []
	
	for node in all_nodes:
		if node.has_method("is_blood"):
			blood_pools.append(node)
	
	if blood_pools.is_empty():
		target = null
		cleaning = false
		return
	
	var closest_pool = null
	var closest_distance = INF
	
	for pool in blood_pools:
		var distance = parent.global_position.distance_to(pool.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_pool = pool
	
	if closest_pool != null:
		cleaning = true
		target = closest_pool
	else:
		cleaning = false
		target = null

func get_attack_direction():
	if target == null:
		return Vector2.ZERO
	
	return (target.global_position - parent.global_position)

func get_attack_target():
	return null
