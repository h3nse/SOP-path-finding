extends PathFinding

var grid
var source
var destination
var srcNode
var destNode
var queue = []
var currentNode
var foundDest

func init(_grid, _source, _destination):
	grid = _grid
	grid.position = Vector2(grid.grid.size() * 35 + 20, 0)
	add_child(grid)
	source = _source
	destination = _destination - Vector2(1,1)
	srcNode = grid.grid[source.x][source.y]
	destNode = grid.grid[destination.x][destination.y]
	srcNode.isSrc = true
	destNode.isDest = true

#func bfs():
#	populate_grid(grid, obstacle_ratio)
#	srcNode.g = 0
#	queue = []
#	queue.append(srcNode)
#	currentNode = _node.instantiate() # Placeholder
#	foundDest = false
#	$Tick.start(tickSpeed)
#
#func _on_tick_timeout():
#	currentNode.isClosed = true
#	if foundDest:
#		found_destination()
#	elif queue.size() > 0:
#		tick()
#	else:
#		print("Failed to find the destination")
#		$Rerun.start(rerunDelay)
#
#func tick():
#	currentNode = queue.pop_front()
#	currentNode.isCurrent = true
#
#	for neighbour in get_neighbours(grid, grid_dimensions, currentNode):
#		if neighbour.isClosed or neighbour.isObstacle:
#			continue
#
#		if neighbour.x == destNode.x and neighbour.y == destNode.y:
#				neighbour.parent = currentNode
#				foundDest = true
#
#		neighbour.isClosed = true
#		neighbour.g = currentNode.g + 1
#		neighbour.parent = currentNode
#		queue.append(neighbour)
#
#	$Tick.start(tickSpeed)
#
#func found_destination():
#	trace_path(currentNode)
#	$Rerun.start(rerunDelay)
#
#func _on_rerun_timeout():
#	bfs()
