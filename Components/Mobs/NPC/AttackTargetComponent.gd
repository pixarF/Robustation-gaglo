class_name AttackTargetComponent extends BaseMobBehaviorComponent

@onready var move_to_target_component: MoveToTargetComponent = parent.get_node_or_null("MoveToTargetComponent")
@onready var weapon_user_component: WeaponUserComponent = parent.get_node_or_null("WeaponUserComponent")
@onready var mob_mover_component: MobMoverComponent = parent.get_node_or_null("MobMoverComponent")

var attack_direction

func _ready() -> void:
	super._ready()
	
	if move_to_target_component == null:
		move_to_target_component = parent.get_node_or_null("MoveToTargetComponent")
	if weapon_user_component == null:
		weapon_user_component = parent.get_node_or_null("WeaponUserComponent")
	if mob_mover_component == null:
		mob_mover_component = parent.get_node_or_null("MobMoverComponent")
		
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if move_to_target_component == null or weapon_user_component == null:
		return
	
	if mob_mover_component != null:
		if mob_mover_component.fallen == true:
			return
	
	if move_to_target_component.target == null or weapon_user_component.selected_weapon == null:
		return
	
	attack_direction = move_to_target_component.target.global_position - parent.global_position
	
	var weapon = weapon_user_component.selected_weapon
	
	if weapon is MeleeWeapon:
		if attack_direction.length() > weapon.attack_range:
			return
		weapon_user_component.attack(self)
	elif weapon.bullets != 0:
		weapon_user_component.attack(self)

func get_attack_direction():
	return attack_direction

func get_attack_target():
	if move_to_target_component != null:
		return move_to_target_component.target
	else:
		return null
