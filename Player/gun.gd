extends Node3D

@export var speed := 20.0
var initial_offset := Transform3D()
var initial_scale := Vector3()

func _ready() -> void:
	initial_offset = get_parent().global_transform.affine_inverse() * global_transform
	initial_scale = scale

func _physics_process(delta: float) -> void:
	var parent_transform = get_parent().global_transform
	global_transform.origin = (parent_transform * initial_offset).origin

	var weight = delta * speed
	var target_rotation = parent_transform.basis * initial_offset.basis

	global_transform.basis = global_transform.basis.orthonormalized()
	target_rotation = target_rotation.orthonormalized()

	global_transform.basis = global_transform.basis.slerp(target_rotation, weight)

	scale = initial_scale
