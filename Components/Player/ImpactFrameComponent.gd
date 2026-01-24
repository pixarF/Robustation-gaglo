class_name ImpactFrameComponent extends Component

@export var effect_frame: ColorRect

func impact_frame(impact_time = 0.3, wait_time = 0.0):
	if wait_time != 0:
		await(get_tree().create_timer(wait_time, true, false, true).timeout)
	effect_frame.visible = true
	frame_freeze(impact_time)
	await(get_tree().create_timer(impact_time, true, false, true).timeout)
	effect_frame.visible = false

func frame_freeze(impact_time = 0.3):
	get_tree().paused = true
	await(get_tree().create_timer(impact_time, true, false, true).timeout)
	get_tree().paused = false

func _ready() -> void:
	EventBusManager.explosion.connect(on_exlosion)

func on_exlosion(explosion):
	if explosion.impact_frame == false:
		return
	impact_frame()
