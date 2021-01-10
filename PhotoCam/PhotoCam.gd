extends Node

export var photoRes = Vector2(300, 350)
export var photoPreviewScale = 0.5

## item detection properties
# must be at least this amount within the frame to be detected
export var captureBufferSize = 25 

var toggleCamera = true



func _ready():
	$PreviewPanel.rect_min_size = photoRes
	$PhotoPreview.rect_size = photoRes * photoPreviewScale
	$PhotoPreview/PreviewPanel2.rect_size = photoRes * photoPreviewScale
	
	toggle_camera()

func _process(delta):
	if toggleCamera:
		if Input.is_action_just_pressed("interact"):
			take_photo()
	else:
		pass

func take_photo():
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
	var preview_size = photoRes * photoPreviewScale
	var imgDest = Image.new()
	imgDest.create(zone.size.x, zone.size.y, false, img.get_format())
	imgDest.blit_rect(img, zone, Vector2.ZERO)
	imgDest.resize(preview_size.x, preview_size.y)
	
	# Create a texture for it.
	var tex = ImageTexture.new()
	tex.create_from_image(imgDest)
	$PhotoPreview.set_texture(tex)
	$PhotoPreview.modulate.a = 1

	check_items_in_photo()

#	yield(get_tree().create_timer(1.5), "timeout")
#	fade_out_preview()
	
func fade_out_preview():
	var tween = $Tween
	tween.interpolate_property($PhotoPreview, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func check_items_in_photo():
	# find all basic interact nodes in scene
	var current_scene = null
	var root = get_tree().get_root()
	current_scene = get_tree().get_nodes_in_group("Items")
	var items = Array()
	for obj in current_scene:
		if obj.get_script() != null:
			if obj is BaseInteract:
				items.append(obj)
			
	var cam : Camera = Global.current_cam	
	var camScreenMin = $PreviewPanel.rect_global_position
	camScreenMin += Vector2.ONE * captureBufferSize
	var camScreenMax = $PreviewPanel.rect_global_position + $PreviewPanel.rect_size
	camScreenMax -= Vector2.ONE * captureBufferSize
	for item in items:
		var itemPos = cam.unproject_position(item.transform.origin)
		if itemPos.x > camScreenMin.x and itemPos.x < camScreenMax.x and itemPos.y > camScreenMin.y and itemPos.y < camScreenMax.y:
			print(item.name + " detected!")

func toggle_camera():
	toggleCamera = !toggleCamera
	if toggleCamera:
		$PreviewPanel.visible = true
	else:
		$PreviewPanel.visible = false
	return toggleCamera
