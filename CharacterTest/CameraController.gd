extends SpringArm3D

@export var rotation_speed := 150.0
@export var max_rotation := 45
@export var min_rotation := 0
@export var deaccel_treshold := 10.0
@export var deaccel_curve : Curve

var input_dir := Vector2.ZERO

@onready var root := $".."

func _physics_process(delta):
	get_inputs()
	apply_rotation(delta)

func get_inputs():
	input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("camera_up"):
		input_dir.y += 1
	if Input.is_action_pressed("camera_down"):
		input_dir.y -= 1
	if Input.is_action_pressed("camera_right"):
		input_dir.x -= 1
	if Input.is_action_pressed("camera_left"):
		input_dir.x += 1
	
	input_dir = input_dir.normalized()

func apply_rotation(delta : float):
	root.rotation_degrees.y += input_dir.x * rotation_speed * delta
	var custom_vertical_speed = rotation_speed
	if input_dir.y > 0 and rotation_degrees.x > (min_rotation - deaccel_treshold):
		custom_vertical_speed = deaccel_curve.sample(1 - abs(rotation_degrees.x - min_rotation)/deaccel_treshold) * rotation_speed
	elif input_dir.y < 0 and rotation_degrees.x < (-max_rotation + deaccel_treshold):
		custom_vertical_speed = deaccel_curve.sample(1 - abs(rotation_degrees.x + max_rotation)/deaccel_treshold) * rotation_speed
	rotation_degrees.x += input_dir.y * custom_vertical_speed * delta
	
	rotation_degrees.x = clamp(rotation_degrees.x, -max_rotation, min_rotation)

