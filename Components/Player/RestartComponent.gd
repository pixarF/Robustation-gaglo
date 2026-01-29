class_name RestartComponent extends Component

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var input = Input.is_action_just_pressed("Restart")
	
	if input:
		get_tree().reload_current_scene()
		Engine.time_scale = 1
