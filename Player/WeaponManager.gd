extends Node3D

@export var speed := 20.0
var initial_offset := Transform3D()
var initial_scale := Vector3()

@onready var rifle: Node3D = $Rifle
@onready var smg: Node3D = $SMG


func _ready() -> void:
	initial_offset = get_parent().global_transform.affine_inverse() * global_transform
	initial_scale = scale
	equip_weapon(smg)

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
		else:
			child.visible = false
			child.set_process(false)

func cycle_weapon() -> void:
	var index = get_current_index()
	print("CURRENT INDEX: ", index)
	if Input.is_action_pressed("next_weapon"):
		index = wrapi(index + 1, 0, get_child_count())
		equip_weapon(get_child(index))
	elif Input.is_action_pressed("previous_weapon"):
		index = wrapi(index - 1, 0, get_child_count())
		equip_weapon(get_child(index))
	print("NEW INDEX: ", index)
	
func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible == true:
			return index
	return 0

func _physics_process(delta: float) -> void:
	
	var parent_transform = get_parent().global_transform
	global_transform.origin = (parent_transform * initial_offset).origin

	var weight = delta * speed
	var target_rotation = parent_transform.basis * initial_offset.basis

	global_transform.basis = global_transform.basis.orthonormalized()
	target_rotation = target_rotation.orthonormalized()

	global_transform.basis = global_transform.basis.slerp(target_rotation, weight)

	scale = initial_scale
