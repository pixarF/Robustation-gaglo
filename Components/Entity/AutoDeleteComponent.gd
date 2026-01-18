class_name AutoDeleteComponent extends Component

@export var lifetime: float = 2

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	parent.queue_free()
