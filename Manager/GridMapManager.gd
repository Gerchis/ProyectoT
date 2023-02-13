extends Node

var target_acceptance := 0.07

func get_grid_pos(_pos : Vector3) -> Vector2:
	var result = Vector2.ZERO
	result = Vector2(roundi(_pos.x), roundi(_pos.z))
	return result

func get_path_direction(_pos_actual : Vector3, _pos_target : Vector3) -> Vector3:
	var result = _pos_target - _pos_actual
	
	if result.length_squared() <= pow(target_acceptance,2.0):
		result = Vector3.ZERO
	
	return result
