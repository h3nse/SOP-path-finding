extends Node2D

@export var tickSpeed = 0.02
@export var rerunDelay = 2
@export var allowDiagonals = false

@export_group("Grid")
@export var grid_dimensions = Vector2(25,25)
@export var source = Vector2(0,0)
@export var destination = Vector2(25,25)
@export_range(0,100) var obstacle_ratio = 30

var _node = preload('res://AstarPathNode.tscn')

var grid = []
var srcNode
var destNode
var openList = []
var foundDest
var currentNode

func _ready():
	destination = destination - Vector2(1,1)

	create_grid()
	srcNode = grid[source.x][source.y]
	destNode = grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true
	astar()

func create_grid():
	for i in range(grid_dimensions.x):
		grid.append([])
		for j in range(grid_dimensions.y):
			var node = _node.instantiate()
			node.init(i,j)
			grid[i].append(node)
			add_child(node)

func add_obstacles():
	for i in grid:
		for j in i:
			j.reset()
			if randi_range(0, 100) < obstacle_ratio:
				j.isObstacle = true

func astar():
	add_obstacles()
	srcNode.g = 0
	srcNode.h = 0
	srcNode.f = 0
	openList = []
	openList.append(srcNode)
	currentNode = _node.instantiate() # Placeholder
	foundDest = false
	$Tick.start(tickSpeed)

func _on_rerun_timeout():
	astar()

func astar_tick():
	currentNode = get_lowest_f()
	openList.remove_at(openList.find(currentNode))
	currentNode.isCurrent = true

	var neighbours = get_neighbours()
	for neighbour in neighbours:
		if neighbour.isClosed or neighbour.isObstacle:
			continue

		if neighbour.x == destNode.x and neighbour.y == destNode.y:
			neighbour.parent = currentNode
			foundDest = true

		var g = currentNode.g + 1
		var h = calculateH(neighbour)
		var f = g + h

		if not openList.has(neighbour):
			neighbour.g = g
			neighbour.h = h
			neighbour.f = f
			neighbour.parent = currentNode
			openList.append(neighbour)
		elif g < neighbour.g:
			neighbour.g = g
			neighbour.f = f
			neighbour.parent = currentNode

	$Tick.start(tickSpeed)

func _on_tick_timeout():
	currentNode.isClosed = true
	if foundDest:
		found_destination()
	elif openList.size() > 0:
		astar_tick()
	else:
		print("Failed to find the destination")
		$Rerun.start(rerunDelay)

func get_lowest_f():
	var lowestIndex = 0
	for i in range(1, openList.size()):
		if openList[i].f < openList[lowestIndex].f:
			lowestIndex = i
	return openList[lowestIndex]

func get_neighbours():
	var neighbours = []
	var localOffsets = [[1,0], [-1,0], [0,1], [0,-1]]
	if allowDiagonals:
		localOffsets = [[1,0], [-1,0], [0,1], [0,-1], [1,1], [-1,1], [-1,-1], [1,-1]]
	for i in range(localOffsets.size()):
		var coords = [currentNode.x + localOffsets[i][0],currentNode.y + localOffsets[i][1]]
		if  0 <= coords[0] and coords[0] <= grid_dimensions.x - 1 and 0 <= coords[1] and coords[1] <= grid_dimensions.y - 1:
			neighbours.append(grid[coords[0]][coords[1]])
	return neighbours

func calculateH(node):
	return abs(node.x - destNode.x) + abs(node.y - destNode.y)

func found_destination():
	trace_path(currentNode)
	$Rerun.start(rerunDelay)

func trace_path(node):
	while not node.parent == null:
		node.modulate = Color.BLUE
		node = node.parent
