extends KinematicBody

export var ACCELERATION = 50
export var DRAG = 25
export var MAX_SPEED = 7.5

var velocity = Vector3()

func _ready():
	sGrid.set_player(self)

func _physics_process(delta):
	var axis = get_axis_input() as Vector3
	
	if axis.length() <= 0.0:
		apply_drag(DRAG * delta)
		$AnimationPlayer.play("PC_idle")
	else:
		apply_acceleration(axis * ACCELERATION * delta)
		look_at(global_transform.origin + velocity, Vector3.UP)
		$AnimationPlayer.play("PC_walk")
	
	move_and_slide(velocity)
	
func _process(delta):
	update_interactor()
	
	if Input.is_action_just_pressed("interact"):
		var interacted = sGrid.get_interacted()
		if interacted:
			interacted.interact()

func get_axis_input():
	var axis = Vector3()
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
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
		
func update_interactor():
	var interactPos = global_transform.origin - (global_transform.basis.z * sGrid.gridScale * 2)
	var interactSpace = sGrid.get_grid(interactPos)
	sGrid.set_interact_space(interactSpace)
