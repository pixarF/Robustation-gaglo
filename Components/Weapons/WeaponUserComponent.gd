class_name WeaponUserComponent extends Component

@export var selected_weapon: Weapon : set = select_weapon
@onready var weapon_texture: DirectionalSprite = parent.get_node("WeaponTexture")

@export var timers_timescaled: bool = true

func _ready() -> void:
	if weapon_texture == null:
		weapon_texture = DirectionalSprite.new()
		weapon_texture.region_enabled = true
		parent.add_child(weapon_texture)
	
	if selected_weapon != null:
		select_weapon(selected_weapon)

func select_weapon(new_weapon: Weapon):
	if new_weapon == null or (selected_weapon != null and selected_weapon.swinging == true):
		return
	
	selected_weapon = new_weapon
	selected_weapon.timers_timescaled = timers_timescaled
	
	if selected_weapon.equipped_texture != null and weapon_texture != null:
		weapon_texture.texture = selected_weapon.equipped_texture

func attack(raiser):
	selected_weapon.attack(raiser)
