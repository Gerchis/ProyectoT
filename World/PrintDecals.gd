extends MeshInstance3D

@onready var decal = preload("res://CellDecals.tscn")
@export var width := 11
@export var heigth := 11

var rotate := false

func _ready():
	
	for i in range(-heigth/2, heigth/2):
		for j in range(-width/2, width/2):
			var new_decal = decal.instantiate()
			new_decal.global_transform.origin = Vector3(i,0,j)
			if rotate:
				new_decal.set_rotation_degrees(Vector3(0,90,0))
				rotate = false
			else:
				rotate = true
			$"../MeshInstance3D3".add_child(new_decal)
		
		rotate = !rotate
