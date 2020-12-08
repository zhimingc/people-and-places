extends Camera

func _process(delta):
	if (Global.current_cam):
		var curTransform = Global.current_cam.get_camera_transform()
		global_transform = curTransform
