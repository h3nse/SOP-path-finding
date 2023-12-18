extends PathFinding

@onready var grid = $Grid
@onready var time = $TimeLabel

var queue = []
var srcNode
var destNode
var currentNode
var foundDest

signal done

func init(grid_dimensions, source, destination):
	grid.init(grid_dimensions)
	grid.position = Vector2(grid.grid.size() * 35 + 20, 20)
	time.position = Vector2(2 * grid.grid.size() * 35 - 20, 0)

	srcNode = grid.grid[source.x][source.y]
	destNode = grid.grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true

func reset(newGrid):
	grid.set_obstacles(newGrid)
	time.text = ""
	queue = []
	queue.append(srcNode)
	currentNode = srcNode
	foundDest = false

func on_tick():
	currentNode.isClosed = true # Is already true except for the src node. This is simply to change the color back to being closed.
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

		if neighbour.isDest:
			foundDest = true

		neighbour.isClosed = true
		neighbour.parent = currentNode
		queue.append(neighbour)
