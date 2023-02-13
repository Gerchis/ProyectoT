extends CharacterBody3D
class_name CharacterTest

var target_pos := Vector3.ZERO
var actual_pos := Vector3.ZERO
var can_move := true

var input_dir := Vector2.ZERO

@export var speed : float  = 0.0

@onready var camera : Camera3D = $Node3D/SpringArm3D/Camera3D

func _ready():
	actual_pos = Vector3(GridMapManager.get_grid_pos(global_transform.origin).x, global_transform.origin.y, GridMapManager.get_grid_pos(global_transform.origin).y)
	target_pos = actual_pos

func _process(delta):
	input_dir = get_input()


func _physics_process(delta):
	actual_pos = Vector3(GridMapManager.get_grid_pos(global_transform.origin).x, global_transform.origin.y, GridMapManager.get_grid_pos(global_transform.origin).y)
	
	if can_move and input_dir != Vector2.ZERO:
		target_pos = actual_pos + get_relative_dir()
		can_move = false
	
	if !can_move and GridMapManager.get_path_direction(global_transform.origin, target_pos) != Vector3.ZERO:
		var next_direction = GridMapManager.get_path_direction(global_transform.origin, target_pos)
		var actual_speed = speed
		if GridMapManager.get_path_direction(global_transform.origin, target_pos).length_squared() <= pow(speed * delta, 2):
			actual_speed = GridMapManager.get_path_direction(global_transform.origin, target_pos).length()
		var new_velocity = (next_direction).normalized() * actual_speed
		set_velocity(new_velocity)
		
		move_and_slide()
	elif !can_move and  GridMapManager.get_path_direction(global_transform.origin, target_pos) == Vector3.ZERO:
		can_move = true

func get_input() -> Vector2:
	var result = Vector2.ZERO
	if Input.is_action_pressed("forward"):
		result.x += 1
	elif Input.is_action_pressed("backward"):
		result.x -= 1
	elif Input.is_action_pressed("right"):
		result.y -= 1
	elif Input.is_action_pressed("left"):
		result.y += 1
	return result

func get_relative_dir() -> Vector3:
	var result = Vector3.ZERO
	var forward = Vector3(camera.get_global_transform().basis.z.x, 0, camera.get_global_transform().basis.z.z)
	var right = Vector3(camera.get_global_transform().basis.x.x, 0, camera.get_global_transform().basis.x.z)
	var actual_input_dir = Vector3(input_dir.x, 0, input_dir.y) 
	if forward.dot(actual_input_dir) <= -0.5:
		print("forward")
		result.x += 1
	elif forward.dot(actual_input_dir) <= 0.5:
		print("Lateral")
		if right.dot(actual_input_dir) <= 0:
			result.z += 1
		else:
			result.z -= 1
	else:
		print("backward")
		result.x -= 1
	
	print(result)
	return result.normalized()
