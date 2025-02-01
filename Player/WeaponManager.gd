extends Node3D

@onready var rifle: Node3D = $Rifle
@onready var smg: Node3D = $SMG


func _ready() -> void:
	equip_weapon(smg)

func _process(delta: float) -> void:
	global_position = get_parent().global_position

func _physics_process(delta: float) -> void:
	global_transform = global_transform.interpolate_with(
		get_parent().global_transform, 50 * delta
	)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_1"):
		equip_weapon(smg)
	else:
		if event.is_action_pressed("weapon_2"):
			equip_weapon(rifle)
	if event.is_action_pressed("next_weapon") or event.is_action_pressed("previous_weapon"):
		cycle_weapon()

func equip_weapon(weapon: Node3D) -> void:
	for child in get_children():
		if child == weapon:
			child.visible = true
			child.set_process(true)
			child.ammo_manager.update_ammo_label(child.ammo_type)
		else:
			child.visible = false
			child.set_process(false)

func cycle_weapon() -> void:
	var index = get_current_index()
	if Input.is_action_pressed("next_weapon"):
		index = wrapi(index + 1, 0, get_child_count())
		equip_weapon(get_child(index))
	elif Input.is_action_pressed("previous_weapon"):
		index = wrapi(index - 1, 0, get_child_count())
		equip_weapon(get_child(index))
	
func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible == true:
			return index
	return 0

