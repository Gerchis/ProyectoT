extends SpringArm3D

@export var rotation_speed := 1

func _process(delta):
	var input_dir = get_input_dir()
	
	rotate_z(input_dir.y * delta * rotation_speed)
	get_parent().rotate_y(input_dir.x * delta * rotation_speed)


func get_input_dir() -> Vector2:
	var result = Vector2.ZERO
	
	if Input.is_action_pressed("camera_up"):
		result.y += 1
	if Input.is_action_pressed("camera_down"):
		result.y -= 1
	if Input.is_action_pressed("camera_right"):
		result.x += 1
	if Input.is_action_pressed("camera_left"):
		result.x -= 1
	
	return result.normalized()
