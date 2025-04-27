extends CharacterBody3D

@export var speed : float = 4.0
@export var run_speed : float = 8.0
@export var acceleration : float = 0.2
@export var jump_force : float = 4.0
@export var gravity : float = 18.0
@export var sensitivity : float = 0.003

@onready var head : Node3D = get_node("Head")
@onready var camera : Camera3D = get_node("Head/Camera3D")
@onready var collision : CollisionShape3D = get_node("CollisionShape3D")

func _enter_tree() -> void:
	var id = str(name).to_int()
	if id != 0:
		set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

func _process(delta):
	if not is_multiplayer_authority(): return

	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE 
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED 
			else Input.MOUSE_MODE_CAPTURED)

	var move_dir = Vector3.ZERO
	var max_speed = speed

	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		if Input.is_action_pressed("run"):
			max_speed = run_speed
		
		if Input.is_action_just_pressed("jump") && is_on_floor():
			velocity.y += jump_force

		move_dir = Input.get_vector("left", "right", "up", "down").normalized()
		move_dir = (head.basis * Vector3(move_dir.x, 0, move_dir.y)).normalized()
	
	if !is_on_floor():
		velocity.y -= gravity * delta

	if move_dir.length_squared() > 0.0001:
		var h_velocity = Vector3(velocity.x, 0, velocity.z) + move_dir
		if h_velocity.length() > max_speed:
			h_velocity = h_velocity.normalized() * max_speed
		velocity = Vector3(h_velocity.x, velocity.y, h_velocity.z)
	else:
		var h_velocity = Vector3(velocity.x, 0, velocity.z)
		h_velocity = h_velocity.move_toward(Vector3.ZERO, acceleration)
		velocity = Vector3(h_velocity.x, velocity.y, h_velocity.z)
	
	move_and_slide()

func _input(event):
	if not is_multiplayer_authority(): return
		
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE && event is InputEventMouseMotion:
		head.rotate_y(event.relative.x * sensitivity * -1)
		camera.rotate_x(event.relative.y * sensitivity * -1)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))