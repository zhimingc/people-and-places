extends Sprite3D

func _process(_delta):
	global_transform.origin = sGrid.grid_space_to_world(sGrid.interact_space)
