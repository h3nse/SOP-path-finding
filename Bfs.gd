extends Node2D

@export var tickSpeed = 0.02
@export var rerunDelay = 2
@export var allowDiagonals = false

@export_group("Grid")
@export var grid_dimensions = Vector2(25,25)
@export var source = Vector2(0,0)
@export var destination = Vector2(25,25)
@export_range(0,100) var obstacle_ratio = 30

var _node = preload("res://bfsPathNode.tscn")

var grid = []
var srcNode
var destNode
var queue = []
var currentNode
var foundDest

func _ready():
	destination = destination - Vector2(1,1)

	create_grid()
	srcNode = grid[source.x][source.y]
	destNode = grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true
	bfs()

func create_grid():
	for i in range(grid_dimensions.x):
		grid.append([])
		for j in range(grid_dimensions.y):
			var node = _node.instantiate()
			node.init(i,j)
			grid[i].append(node)
			add_child(node)

func populate_grid():
	for i in grid:
		for j in i:
			j.reset()
			if randi_range(0, 100) < obstacle_ratio:
				j.isObstacle = true

func bfs():
	populate_grid()
	srcNode.g = 0
	queue = []
	queue.append(srcNode)
	currentNode = _node.instantiate() # Placeholder
	foundDest = false
	$Tick.start(tickSpeed)

func _on_tick_timeout():
	currentNode.isClosed = true
	if foundDest:
		found_destination()
	elif queue.size() > 0:
		tick()
	else:
		print("Failed to find the destination")
		$Rerun.start(rerunDelay)

func tick():
	currentNode = queue.pop_front()
	currentNode.isCurrent = true

	for neighbour in get_neighbours():
		if neighbour.isClosed or neighbour.isObstacle:
			continue

		if neighbour.x == destNode.x and neighbour.y == destNode.y:
				neighbour.parent = currentNode
				foundDest = true

		neighbour.isClosed = true
		neighbour.g = currentNode.g + 1
		neighbour.parent = currentNode
		queue.append(neighbour)

	$Tick.start(tickSpeed)

func found_destination():
	trace_path(currentNode)
	$Rerun.start(rerunDelay)

func trace_path(node):
	while not node.parent == null:
		node.modulate = Color.BLUE
		node = node.parent

func _on_rerun_timeout():
	bfs()

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
