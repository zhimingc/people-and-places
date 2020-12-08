extends Node

export var photoRes = Vector2(300, 250)

var toggleCamera = true

func _ready():
	$PreviewPanel.rect_size = photoRes
	$PhotoPreview.rect_size = photoRes
	$PhotoPreview/PreviewPanel2.rect_size = photoRes
	
	toggle_camera()
	

func _process(delta):
	if toggleCamera:
		if Input.is_action_just_pressed("interact"):
			update_photo_preview()
	else:
		pass

func update_photo_preview():
	var cam = Global.current_cam
	var old_clear_mode = get_viewport().get_clear_mode()
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Let two frames pass to make sure the screen was captured.
	# yield(get_tree(), "idle_frame")
	# yield(get_tree(), "idle_frame")
	
	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_data()
	# restore the previous value, as some part wont redraw after...
	get_viewport().set_clear_mode(old_clear_mode)
	
	# Flip it on the y-axis (because it's flipped).
	img.flip_y()
	
	var zone = Rect2($PreviewPanel.rect_global_position, $PreviewPanel.rect_size)
	
	# copy to a new image, I need to create it first with the same size with create()
	var imgDest = Image.new()
	imgDest.create(zone.size.x, zone.size.y, false, img.get_format())
	imgDest.blit_rect(img, zone, Vector2.ZERO)
	
	# Create a texture for it.
	var tex = ImageTexture.new()
	tex.create_from_image(imgDest)
	$PhotoPreview.set_texture(tex)

	$PhotoPreview.modulate.a = 1
	yield(get_tree().create_timer(1.5), "timeout")
	fade_out_preview()
	
func fade_out_preview():
	var tween = $Tween
	tween.interpolate_property($PhotoPreview, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func toggle_camera():
	toggleCamera = !toggleCamera
	if toggleCamera:
		$PreviewPanel.visible = true
	else:
		$PreviewPanel.visible = false		
