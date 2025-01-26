extends Node3D

@export var speed := 20.0
var initial_offset := Transform3D()
var initial_scale := Vector3()

@onready var rifle: Node3D = $Rifle
@onready var smg: Node3D = $SMG


func _ready() -> void:
	initial_offset = get_parent().global_transform.affine_inverse() * global_transform
	initial_scale = scale
	equip_weapon(rifle)

func equip_weapon(weapon: Node3D) -> void:
	for child in get_children():
		if child == weapon:
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)
		
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("weapon_1"):
		equip_weapon(smg)
	else:
		if Input.is_action_just_pressed("weapon_2"):
			equip_weapon(rifle)
	
	var parent_transform = get_parent().global_transform
	global_transform.origin = (parent_transform * initial_offset).origin

	var weight = delta * speed
	var target_rotation = parent_transform.basis * initial_offset.basis

	global_transform.basis = global_transform.basis.orthonormalized()
	target_rotation = target_rotation.orthonormalized()

	global_transform.basis = global_transform.basis.slerp(target_rotation, weight)

	scale = initial_scale
