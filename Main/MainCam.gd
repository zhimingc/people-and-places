extends Camera

var pc
var offset

# Called when the node enters the scene tree for the first time.
func _ready():
	pc = get_node("/root/Main/PC")
	offset = global_transform.origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin = offset + pc.global_transform.origin
	
