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
	EventBusManager.kick_dash_combo.connect(on_kickdash_combo)

func on_exlosion(explosion):
	if explosion.impact_frame == false:
		return
	impact_frame()

func on_kickdash_combo(emitter):
	if emitter != parent:
		return
	
	impact_frame(0.1, 0.1)
