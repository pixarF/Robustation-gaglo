@abstract
class_name BaseXOnTriggerComponent extends Component

@export var key: String = "Trigger"

func _ready() -> void:
	for child in parent.get_children():
		if child is BaseTriggerOnXComponent and child.key == key:
			child.on_trigger.connect(on_trigger)

func on_trigger():
	pass
