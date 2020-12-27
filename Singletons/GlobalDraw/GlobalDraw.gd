extends Node

var loadPath = "res://Singletons/GlobalDraw/"
var point3d = load(loadPath + "3d-point.tscn")

func draw_point_3d(pos):
	var inst = point3d.instance()
	# get_tree().get_root().call_deferred("add_child", inst)
	add_child(inst)
	inst.global_transform.origin = pos
