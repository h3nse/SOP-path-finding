class_name PathFinding extends Node2D

func create_grid(grid, grid_dimensions, _node):
	for i in range(grid_dimensions.x):
		grid.append([])
		for j in range(grid_dimensions.y):
			var node = _node.instantiate()
			node.init(i,j)
			grid[i].append(node)
			add_child(node)

func populate_grid(grid, obstacle_ratio):
	for i in grid:
		for j in i:
			j.reset()
			if randi_range(0, 100) < obstacle_ratio:
				j.isObstacle = true

func get_neighbours(grid, grid_dimensions, currentNode, allowDiagonals):
	var neighbours = []
	var localOffsets = [[1,0], [-1,0], [0,1], [0,-1]]
	if allowDiagonals:
		localOffsets = [[1,0], [-1,0], [0,1], [0,-1], [1,1], [-1,1], [-1,-1], [1,-1]]
	for i in range(localOffsets.size()):
		var coords = [currentNode.x + localOffsets[i][0],currentNode.y + localOffsets[i][1]]
		if  0 <= coords[0] and coords[0] <= grid_dimensions.x - 1 and 0 <= coords[1] and coords[1] <= grid_dimensions.y - 1:
			neighbours.append(grid[coords[0]][coords[1]])
	return neighbours

func trace_path(node):
	while not node.parent == null:
		node.modulate = Color.BLUE
		node = node.parent
