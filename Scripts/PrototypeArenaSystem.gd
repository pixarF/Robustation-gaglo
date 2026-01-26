extends Node2D

var diff: float = 1
var enemies_per_wave = 5
var wave_cleanbots: Array[CharacterBody2D]
@onready var wave_timer = $WaveTimer
@onready var player: CharacterBody2D = $Player
@export var assistant: PackedScene
@export var pun_pun: PackedScene
@export var bartender: PackedScene
@export var cleanbot: PackedScene

func _on_wave_timer_timeout() -> void:
	var clean_array: Array[CharacterBody2D]
	for bot in wave_cleanbots:
		if is_instance_valid(bot):
			clean_array.append(bot)
	wave_cleanbots = clean_array
	
	if wave_cleanbots.is_empty():
		for bot in randi_range(0, 2):
			randomize()
			var x_spawn_pos = player.global_position.x + randf_range(0, 100)
			randomize()
			var y_spawn_pos = player.global_position.y + randf_range(0, 100)
			
			var inst = cleanbot.instantiate()
			inst.global_position = Vector2(x_spawn_pos, y_spawn_pos)
			wave_cleanbots.append(inst)
			add_child(inst)
	
	randomize()
	if randf() * (diff / 3) > 0.5:
		randomize()
		var x_spawn_pos = randf_range(0, 100) + player.global_position.x + randf_range(0, 100)
		randomize()
		var y_spawn_pos = randf_range(0, 100) + player.global_position.y + randf_range(0, 100)
		
		var inst = pun_pun.instantiate()
		inst.global_position = Vector2(x_spawn_pos, y_spawn_pos)
		add_child(inst)
		
		var inst_bar = bartender.instantiate()
		inst_bar.global_position = Vector2(x_spawn_pos, y_spawn_pos)
		add_child(inst_bar)
	
	var mod = 1
	if diff > 2:
		mod = diff
		mod = clamp(mod, 1, 4)
	
	for enemy in randi_range(1, 2 * mod):
		randomize()
		var x_spawn_pos = randf_range(0, 100) + player.global_position.x + randf_range(0, 100)
		randomize()
		var y_spawn_pos = randf_range(0, 100) + player.global_position.y + randf_range(0, 100)
		
		var inst = assistant.instantiate()
		inst.global_position = Vector2(x_spawn_pos, y_spawn_pos)
		add_child(inst)
	
	diff += 0.1
	wave_timer.start()
