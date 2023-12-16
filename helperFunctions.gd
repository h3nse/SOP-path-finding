class_name PathFinding extends Node2D

func get_new_grid(grid_dimensions, obstacle_ratio):
	var grid = []
	for i in grid_dimensions.x:
		grid.append([])
		for j in grid_dimensions.y:
			if randi_range(0, 100) < obstacle_ratio:
				grid[i].append(1)
			else:
				grid[i].append(0)
	return grid

func get_neighbours(grid, currentNode):
	var neighbours = []
	var localOffsets = [[1,0], [-1,0], [0,1], [0,-1]]
	for i in range(4):
		var coords = [currentNode.x + localOffsets[i][0],currentNode.y + localOffsets[i][1]]
		if  0 <= coords[0] and coords[0] <= grid.grid.size() - 1 and 0 <= coords[1] and coords[1] <= grid.grid[0].size() - 1:
			neighbours.append(grid.grid[coords[0]][coords[1]])
	return neighbours

func trace_path(node):
	while not node.parent == null:
		node.modulate = Color.BLUE
		node = node.parent
