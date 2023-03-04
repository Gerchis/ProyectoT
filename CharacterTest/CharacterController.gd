extends CharacterBody3D

@export var speed := 5.0
@export_range(0,1) var wait_to_move := 0.1

var input_direction := Vector2.ZERO
var direction := Vector3.ZERO
var target_pos := Vector3.ZERO
var movement_vector := Vector3.ZERO
var can_move := true
var in_movement := false

@onready var camera := $CameraRoot/SpringArm3D/Camera3D

func _process(delta):
	get_inputs()

func _physics_process(delta):
	set_world_direction()
	cell_movement(delta)
	apply_movement()

func get_inputs():
	input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("forward"):
		input_direction.x -= 1
	if Input.is_action_pressed("backward"):
		input_direction.x += 1
	if Input.is_action_pressed("right"):
		input_direction.y += 1
	if Input.is_action_pressed("left"):
		input_direction.y -= 1
	
	input_direction = input_direction.normalized()

func set_world_direction():
	direction = Vector3.ZERO
	var camera_forward = Vector3(camera.global_transform.basis.z.x, 0, camera.global_transform.basis.z.z)
	var camera_right = Vector3(camera.global_transform.basis.x.x, 0, camera.global_transform.basis.x.z)
	
	direction = (camera_forward * input_direction.x) + (camera_right * input_direction.y)
	direction = direction.normalized()

func apply_movement():
	set_velocity(movement_vector)
	move_and_slide()

func cell_movement(delta):
	if !in_movement and can_move and direction != Vector3.ZERO:
		target_pos = BattleMovementManager.get_target_pos(direction, global_transform.origin)
		in_movement = true
	
	if in_movement and can_move:
		var dir = target_pos - global_transform.origin
		dir.y = 0
		
		if dir.length() < speed*delta:
			global_position = Vector3(target_pos.x, global_position.y, target_pos.z)
			movement_vector = Vector3.ZERO
			in_movement = false
			can_move = false
			get_tree().create_timer(wait_to_move).timeout.connect(cell_movement_finished)
		else:
			movement_vector = dir.normalized() * speed

func cell_movement_finished():
	can_move = true
