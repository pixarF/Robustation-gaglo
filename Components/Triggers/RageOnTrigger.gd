class_name RageOnTriggerComponent extends BaseXOnTriggerComponent

@onready var rage_component: RageComponent = parent.get_node_or_null("RageComponent")

func on_trigger():
	if rage_component != null:
		rage_component.rage()
