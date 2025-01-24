extends CharacterBody3D


const SPEED = 5.0
@export var jump_height : float = 1.0 
@export var fall_multiplier : float = 1.5
@export var max_health : int = 100

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion:= Vector2.ZERO 
var health := max_health:
	set(value):
		if value < health:
			damage_animation_player.stop(false)
			damage_animation_player.play("Damage")

		health = value
		if health <= 0:
			game_over_menu.game_over()

@onready var game_over_menu: Control = $GameOverMenu
@onready var camera_pivot: Node3D = $CameraPivot
@onready var gun_pivot: Node3D = $CameraPivot/GunPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = sqrt(jump_height * 2 * gravity)

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_motion = -event.relative * 0.005
	else:
		if event.is_action_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			if event is InputEventMouseButton:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func handle_camera_rotation() -> void: 
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	gun_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90.0
	) 
	gun_pivot.rotation_degrees.x = clampf(
		gun_pivot.rotation_degrees.x, -90.0, 90.0
	) 
	mouse_motion = Vector2.ZERO
