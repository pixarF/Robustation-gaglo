class_name TrailEffectComponent extends Component

@export var colors: Array[Color]
@export var clean_delay: float = 5
@export var trail_lifetime: float = 2
@export var end_color: Color = Color(1.0, 1.0, 1.0, 0.0)
var last_position: Vector2 = Vector2.ZERO
var required_position_length: int = 20
var color: Color
var color_tween: Tween
var color_change_delay: float = 0.2

var duplicates: Array

@export var lifetime: float = 0
@export var active: bool = true

var lifetime_timer: float = 0
var clean_timer: float = 0
var autodelete_active: bool = false

func _ready() -> void:
	color = Color(1.0, 1.0, 1.0, 1.0)
	parent.modulate = color
	
	color_tween = create_tween()
	for color_from_array in colors:
		color_tween.tween_property(parent, "self_modulate", color_from_array, color_change_delay)
	color_tween.set_loops()
	color_tween.set_trans(Tween.TRANS_SINE)
	color_tween.set_ease(Tween.EASE_IN_OUT)
	
	if lifetime > 0:
		lifetime_timer = lifetime
		autodelete_active = true

func _process(delta: float) -> void:
	if autodelete_active:
		if lifetime_timer > 0:
			lifetime_timer -= delta
			if lifetime_timer <= 0:
				_on_lifetime_end()
		
		if clean_timer > 0:
			clean_timer -= delta
			if clean_timer <= 0:
				_on_clean_delay_end()
	
	if active == false:
		return
	
	var parent_position = parent.global_position
	if (last_position - parent_position).length() < required_position_length:
		return
	
	last_position = parent_position
	
	for children in get_parent().get_children():
		if children is not Sprite2D:
			if not children.has_node("Texture"):
				continue
			children = children.get_node("Texture")
		
		var new_sprite = children.duplicate()
		get_parent().get_parent().add_child(new_sprite)
		new_sprite.global_position = parent_position
		new_sprite.global_rotation = parent.global_rotation
		new_sprite.global_skew = parent.global_skew
		new_sprite.scale = parent.scale
		new_sprite.modulate = parent.self_modulate
		var tween = create_tween()
		tween.tween_property(new_sprite, "modulate", end_color, trail_lifetime)
		
		duplicates.append(new_sprite)

func _on_lifetime_end():
	active = false
	name = "TrailEffectComponentDeactivated"
	clean_timer = clean_delay

func _on_clean_delay_end():
	_clean()
	queue_free()

func _clean():
	color_tween.kill()
	parent.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	for dupl in duplicates:
		if dupl == null:
			continue
		dupl.queue_free()
	duplicates.clear()
