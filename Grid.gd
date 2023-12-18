extends Node2D

var grid = []
var _node = preload("res://PathNode.tscn")

func init(grid_dimensions):
	grid = []
	for i in range(grid_dimensions.x):
		grid.append([])
		for j in range(grid_dimensions.y):
			var node = _node.instantiate()
			node.init(i,j)
			grid[i].append(node)
			add_child(node)

func set_obstacles(newGrid):
	for i in newGrid.size():
		for j in newGrid[i].size():
			grid[i][j].reset()
			if newGrid[i][j] == 1:
				grid[i][j].isObstacle = true
			else:
				grid[i][j].isObstacle = false
