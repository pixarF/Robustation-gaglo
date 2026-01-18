class_name OverdoseAbilityComponent extends BaseAbilityComponent

@onready var mob_mover_component: MobMoverComponent = parent.get_node_or_null("MobMoverComponent")

@export var trail_colors: Array[Color]

var speed_modification: int
var acceleration_modification: int
var friction_modification: int

func activate_ability():
	if mob_mover_component == null:
		return
	
	overdose_effects()
	
	@warning_ignore("narrowing_conversion")
	speed_modification = mob_mover_component.max_speed / Engine.time_scale * 2
	@warning_ignore("narrowing_conversion")
	acceleration_modification = mob_mover_component.acceleration / Engine.time_scale * 2
	@warning_ignore("narrowing_conversion")
	friction_modification = mob_mover_component.acceleration * Engine.time_scale * 30
	
	mob_mover_component.max_speed += speed_modification
	mob_mover_component.acceleration += acceleration_modification
	mob_mover_component.friction += friction_modification
	mob_mover_component.fly_modifier = 0.2
	
	var time_tween = create_tween()
	time_tween.tween_property(Engine, "time_scale", 0.35, 0.5)

func overdose_effects():
	var trail = TrailEffectComponent.new()
	trail.lifetime = ability_delay
	trail.colors = trail_colors
	trail.color_change_delay = ability_delay / trail_colors.size()
	trail.name = "TrailEffectComponent"
	parent.add_child(trail)

func disable_ability():
	var time_tween = create_tween()
	time_tween.tween_property(Engine, "time_scale", 1, 0.5)
	
	mob_mover_component.max_speed -= speed_modification
	mob_mover_component.acceleration -= acceleration_modification
	mob_mover_component.friction -= friction_modification
	mob_mover_component.fly_modifier = 1
