class_name InputMoverComponent extends Component

@onready var mob_mover_component = parent.get_node("MobMoverComponent")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if mob_mover_component == null:
		return
	_set_movement_input()

func _set_movement_input():
	mob_mover_component.direction = Input.get_vector("movement_left","movement_right", "movement_up", "movement_down")
