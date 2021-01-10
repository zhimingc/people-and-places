extends KinematicBody

export var ACCELERATION = 50
export var DRAG = 25
export var MAX_SPEED = 7.5
export var firstPerson = true
export var moveSpeed = 150
export var lookSpeed = 0.1

var viewPitchLimit = 40
var velocity = Vector3()
var cam : Camera
var currentInteract : Node
var holdInteract : Node		# to recover the last person interacted with
var isCameraActive = false

func _ready():
	cam = get_viewport().get_camera()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	
func _physics_process(delta):
	var axis = get_axis_input() as Vector3
	
	if axis.length() <= 0.0:
		apply_drag(DRAG * delta)
		$AnimationPlayer.play("PC_idle")
	else:
		if firstPerson:
			axis = axis.rotated(Vector3.UP, cam.rotation.y)
		apply_acceleration(axis * ACCELERATION * delta)
		# look_at(global_transform.origin + velocity, Vector3.UP)
		$AnimationPlayer.play("PC_walk")
	
	move_and_slide(velocity)
	
func _process(delta):
	update_interact()
	if Input.is_action_just_pressed("camera"):
		isCameraActive = !isCameraActive
		if isCameraActive: 
			$arms/arm_anim.play("cam_up")
		else:
			$arms/arm_anim.play("cam_down")			
		
	update_body()

func _input(event):
	if event is InputEventMouseMotion:
		update_camera(event.relative)

# update body mesh to align with view
func update_body():
	$arms.global_transform.basis = cam.global_transform.basis
	
func update_camera(mouseRelative):
	cam.global_rotate(Vector3.UP, deg2rad(-mouseRelative.x * lookSpeed))
	cam.rotate_object_local(Vector3.RIGHT, deg2rad(-mouseRelative.y * lookSpeed))
	cam.rotation.x = clamp(cam.rotation.x, deg2rad(-viewPitchLimit), deg2rad(viewPitchLimit))

func get_axis_input():
	var axis = Vector3()
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if !firstPerson:
		# orient axis based on camera
		var camQuat = get_viewport().get_camera().global_transform.basis.get_rotation_quat()
		axis = camQuat.xform(axis)
		axis.y = 0

	return axis.normalized()
	
func apply_drag(amt):
	if velocity.length() > amt:
		velocity -= velocity.normalized() * amt
	else:
		velocity = Vector3()
	
func apply_acceleration(acc):
	velocity += acc
	if velocity.length() >= MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

func update_interact():
	# get all overlapping with sphere collision
	
	# 3d angle check to simulate cone
	
	# distance check to get closest
	
	# check for input
	if currentInteract and !isCameraActive and Input.is_action_just_pressed("interact"):
		Dialogue.show_message()

func _on_Interact_body_entered(body):
	if !isCameraActive:
		set_interact(body)
	elif holdInteract == null:
		holdInteract = body
		
func _on_Interact_body_exited(body):
	if body == currentInteract:
		currentInteract = null
		Dialogue.toggle_prompt(-1)
		Dialogue.hide_message()
	if body == holdInteract:
		holdInteract = null
		
func set_interact(body):
	currentInteract = body
	holdInteract = body	
	Dialogue.toggle_prompt(1)
	# print("Interacting with: " + body.get_parent().name)
	
func toggle_camera():
	var camActive = $PhotoCameraController.toggle_camera()
	Dialogue.toggle_prompt(-1)
	if !camActive and holdInteract:
		set_interact(holdInteract)
