class_name FootstepComponent extends Component

@export var footstep_sound: AudioStreamPlayer2D
@export var footstep_range: int = 64
var last_position = Vector2.ZERO

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if (last_position - parent.global_position).length() > footstep_range:
		last_position = parent.global_position
		if footstep_sound != null:
			footstep_sound.global_position = parent.global_position
			footstep_sound.play()
