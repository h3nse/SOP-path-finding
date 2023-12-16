extends PathFinding

@onready var grid = $Grid
@onready var time = $TimeLabel
var source
var destination
var srcNode
var destNode
var queue = []
var currentNode
var foundDest

signal done

func init(_source, _destination):
	grid.position = Vector2(grid.grid.size() * 35 + 20, 20)
	time.position = Vector2(2 * grid.grid.size() * 35 - 20, 0)
	source = _source
	destination = _destination - Vector2(1,1)
	srcNode = grid.grid[source.x][source.y]
	destNode = grid.grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true

func reset():
	srcNode.g = 0
	queue = []
	queue.append(srcNode)
	currentNode = grid._node.instantiate() # Placeholder
	foundDest = false

func on_tick():
	currentNode.isClosed = true
	if foundDest:
		trace_path(currentNode)
	elif queue.size() > 0:
		tick()
		return
	else:
		print("Failed to find the destination")
	emit_signal("done")

func tick():
	currentNode = queue.pop_front()
	currentNode.isCurrent = true

	for neighbour in get_neighbours(grid, currentNode):
		if neighbour.isClosed or neighbour.isObstacle:
			continue

		if neighbour.x == destNode.x and neighbour.y == destNode.y:
				neighbour.parent = currentNode
				foundDest = true

		neighbour.isClosed = true
		neighbour.g = currentNode.g + 1
		neighbour.parent = currentNode
		queue.append(neighbour)
