extends Node
class_name AmmoManager

enum ammo_type {
	BULLET,
	SMALL_BULLET
}

var ammo_storage := {
	ammo_type.BULLET : 10,
	ammo_type.SMALL_BULLET : 60
}

func has_ammo(type : ammo_type) -> bool:
	return ammo_storage[type] > 0
	
func use_ammo(type: ammo_type) -> void:
	if has_ammo(type):
		ammo_storage[type] -= 1
		print("AMMO RESERVES FOR ", type, ": ", ammo_storage[type])
