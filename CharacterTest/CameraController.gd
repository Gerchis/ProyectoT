extends SpringArm3D

@export var rotation_speed := 150.0

var input_dir := Vector2.ZERO

@onready var root := $".."

func _process(delta):
	get_inputs()
	apply_rotation(delta)

func get_inputs():
	input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("camera_up"):
		input_dir.y += 1
	if Input.is_action_pressed("camera_down"):
		input_dir.y -= 1
	if Input.is_action_pressed("camera_right"):
		input_dir.x += 1
	if Input.is_action_pressed("camera_left"):
		input_dir.x -= 1
	
	input_dir = input_dir.normalized()

func apply_rotation(delta : float):
	
	root.rotation_degrees.y += input_dir.x * rotation_speed * delta
	rotation_degrees.x += input_dir.y * rotation_speed * delta
	
	rotation_degrees.x = clamp(rotation_degrees.x, -45, 0)

