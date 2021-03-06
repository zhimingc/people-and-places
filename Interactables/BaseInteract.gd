extends Spatial

class_name BaseInteract

var foraged
var forageSpawnNum = Vector2(1, 3)
var foragedRange = Vector2(-5, 5)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Items", true)
	foraged = load("res://Interactables/BaseInteract.tscn")
	
	# debug draw origins
	GlobalDraw.draw_point_3d(global_transform.origin)
		
func interact():
	var spawned = rand_range(forageSpawnNum.x, forageSpawnNum.y)
	for i in spawned:
		var spawnPos = Vector3(rand_range(foragedRange.x, foragedRange.y), 0, rand_range(foragedRange.x, foragedRange.y))
		var newForaged = foraged.instance()
		newForaged.global_transform.origin = spawnPos + global_transform.origin
		get_tree().get_root().add_child(newForaged)
	queue_free()
