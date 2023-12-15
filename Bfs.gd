extends PathFinding

@export var tickSpeed = 0.02
@export var rerunDelay = 2

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

	create_grid(grid, grid_dimensions, _node)
	srcNode = grid[source.x][source.y]
	destNode = grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true
	bfs()

func bfs():
	populate_grid(grid, obstacle_ratio)
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

	for neighbour in get_neighbours(grid, grid_dimensions, currentNode):
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

func _on_rerun_timeout():
	bfs()
