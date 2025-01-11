extends Camera3D

@export var speed := 20.0

func _physics_process(delta: float) -> void:
	var weight = delta * speed
	
	global_transform = global_transform.interpolate_with(
		get_parent().global_transform, weight
	)
	global_position = get_parent().global_position
