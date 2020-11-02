extends Control

var grid = {}
var gridScale = 1.5
var drawGrid = false
var debugGridSize = Vector2(9, 9)
var player
var interact_space

func _ready():
	# player = get_tree().get_root().get_node("Main/PC")
	pass

func set_player(node):
	player = node

func set_interact_space(pos):
	interact_space = pos

# returns grid pos in grid space
func get_grid(pos):
	var twoGridDim = gridScale * 2
	var grid = Vector2(round(pos.x / twoGridDim), round(pos.z / twoGridDim))
	return grid

# returns grid pos in world space
func get_grid_pos(pos):
	var gridSpace = get_grid(pos)
	return grid_space_to_world(gridSpace)

func grid_space_to_world(space):
	space *= gridScale * 2
	return Vector3(space.x, 0, space.y)
	
# get node in grid space
func get_node(g_pos):
	var node = null
	if grid.has(g_pos):
		node = grid[g_pos]
	return node	
	
func get_interacted():
	return get_node(interact_space)	

func add_node(node):
	var gridSpace = get_grid(node.global_transform.origin)
	if !grid.has(gridSpace):
		grid[gridSpace] = node
	else:
		print("Trying to add node to an occupied grid space!")
		return false
	return true
	
func _process(delta):
	update()
	
func _draw():
	if !drawGrid:
		return
	var mainCam = get_viewport().get_camera()
	var playerGridPos = Vector3()
	if player:
		playerGridPos = get_grid_pos(player.global_transform.origin)
	var twoGridDim = gridScale * 2
	var drawLimit = (debugGridSize * twoGridDim) / 2
	for x in debugGridSize.x + 1:
		var xPos = -gridScale + (ceil(-debugGridSize.x / 2) + x) * twoGridDim
		var drawStart = mainCam.unproject_position(playerGridPos + Vector3(xPos, 0, -drawLimit.y))
		var drawEnd = mainCam.unproject_position(playerGridPos + Vector3(xPos, 0, drawLimit.y))
		draw_line(drawStart, drawEnd, Color.red, 1.0)
	for y in debugGridSize.y:
		var yPos = -gridScale + (ceil(-debugGridSize.y / 2) + y) * twoGridDim
		var drawStart = mainCam.unproject_position(playerGridPos + Vector3(-drawLimit.x, 0, yPos))
		var drawEnd = mainCam.unproject_position(playerGridPos + Vector3(drawLimit.x, 0, yPos))
		draw_line(drawStart, drawEnd, Color.red, 1.0)

