extends Node

@export var cell_size := 1

func get_target_pos(direction : Vector3, actual_pos : Vector3)->Vector3:
	var result = Vector3.ZERO
	
	var actual_cell = Vector2(round(actual_pos.x/cell_size), round(actual_pos.z/cell_size))
	
	if abs(direction.x) > abs(direction.z):
		if direction.x > 0:
			actual_cell.x += 1
		elif direction.x < 0:
			actual_cell.x -= 1
	elif abs(direction.x) < abs(direction.z):
		if direction.z > 0:
			actual_cell.y += 1
		elif direction.z < 0:
			actual_cell.y -= 1
	
	result = Vector3(actual_cell.x * cell_size, 0, actual_cell.y * cell_size)
	return result
