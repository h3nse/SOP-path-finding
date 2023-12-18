extends PathFinding

@onready var grid = $Grid
@onready var time = $TimeLabel

var openList = []
var srcNode
var destNode
var currentNode
var foundDest

signal done

func init(grid_dimensions, source, destination):
	grid.init(grid_dimensions)
	grid.position = Vector2(0, 20)
	time.position = Vector2(grid.grid.size() * 35 - 30,0)

	srcNode = grid.grid[source.x][source.y]
	destNode = grid.grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true

func reset(newGrid):
	grid.set_obstacles(newGrid)
	time.text = ""
	openList = []
	srcNode.g = 0
	srcNode.h = 0
	srcNode.f = 0
	openList.append(srcNode)
	currentNode = srcNode
	foundDest = false

func on_tick():
	currentNode.isClosed = true
	if foundDest:
		trace_path(currentNode)
	elif openList.size() > 0:
		astar_tick()
		return
	else:
		print("Failed to find the destination")
	emit_signal("done")

func astar_tick():
	currentNode = get_lowest_f()
	openList.remove_at(openList.find(currentNode))
	currentNode.isCurrent = true

	for neighbour in get_neighbours(grid, currentNode):
		if neighbour.isClosed or neighbour.isObstacle:
			continue

		if neighbour.isDest:
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

func get_lowest_f():
	var lowestIndex = 0
	for i in range(1, openList.size()):
		if openList[i].f < openList[lowestIndex].f:
			lowestIndex = i
	return openList[lowestIndex]

func calculateH(node):
	return abs(node.x - destNode.x) + abs(node.y - destNode.y)
