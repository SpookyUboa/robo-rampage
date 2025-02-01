extends Area3D

@export var ammo_type : AmmoManager.ammo_type
@export var amount : int = 20

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Rotation")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.ammo_manager.add_ammo(ammo_type, amount)
		queue_free()
