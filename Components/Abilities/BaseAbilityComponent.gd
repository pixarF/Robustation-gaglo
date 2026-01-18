class_name BaseAbilityComponent extends Component

@export var cooldown: bool = false
@export var cooldown_delay: float = 30

@export var ability_delay: float = 0
@export var cooldown_on_activate: bool = false

@export var start_effect: PackedScene
@export var start_sound: AudioStreamPlayer2D
@export var stop_effect: PackedScene
@export var stop_sound: AudioStreamPlayer2D

var active = false
var ability_timer = 0

func  _ready() -> void:
	if parent.has_node("Sounds"):
		var sounds = parent.get_node("Sounds")
		if start_sound != null:
			start_sound.reparent(sounds)
		if stop_sound != null:
			stop_sound.reparent(sounds)

func _process(delta: float) -> void:
	if ability_timer > 0:
		ability_timer -= delta
		if ability_timer <= 0:
			ability_timer = 0
			if active:
				on_disable_ability()
	
	input()

func input():
	if Input.is_action_just_pressed("ability") and not cooldown and not active:
		on_activate_ability()

func on_activate_ability():
	cooldown = true
	active = true
	
	if cooldown_on_activate:
		_start_cooldown()
	
	activate_ability()
	
	if ability_delay > 0:
		ability_timer = ability_delay
	else:
		on_disable_ability()
	
	if start_sound != null:
		start_sound.play()
	if start_effect != null:
		var inst = start_effect.instantiate()
		inst.global_position = parent.global_position
		scene.add_child(inst)

func on_disable_ability():
	active = false
	
	if cooldown_on_activate == false:
		_start_cooldown()
	
	disable_ability()
	
	if stop_sound != null:
		stop_sound.play()
	if stop_effect != null:
		var inst = stop_effect.instantiate()
		inst.global_position = parent.global_position
		scene.add_child(inst)

func activate_ability():
	pass

func disable_ability():
	pass

func _start_cooldown():
		cooldown = true
		await get_tree().create_timer(cooldown_delay, true, false, true).timeout
		cooldown = false
