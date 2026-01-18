class_name BaseMobBehaviorComponent extends Component

func _ready() -> void:
	if parent is not Node2D:
		parent = parent.get_parent()
