extends Node2D

@export_group("Grid")
@export_range(0,50,1,"or_greater") var ROWS = 10
@export_range(0,50,1,"or_greater") var COLS = 10
@export var SOURCE = Vector2()
@export var GOAL = Vector2()
@export_range(0,100) var OBSTACLE_RATION = 30
@export_group("")

var _node = preload("res://pathNode.tscn")

var grid = []
var isValid = true

func create_grid():
	for x in ROWS:
		grid.append([])
		for y in COLS:
			var node = _node.instantiate()
			node.init(x,y)
			grid[x].append(node)
			add_child(node)

func checkIsValid():
	return (SOURCE.x >= 0 and SOURCE.x < ROWS and SOURCE.y >= 0 and SOURCE.y < COLS
	and GOAL.x >= 0 and GOAL.x < ROWS and GOAL.y >= 0 and GOAL.y < COLS)

func addObstacles():
	for x in range(grid.size()):
		for y in range(grid[x].size()):
			if randi_range(0,100) < OBSTACLE_RATION:
				grid[x][y].isObstacle = true
			else:
				grid[x][y].isObstacle = false

func get_lowest_f(nodeList):
	var lowest_node = nodeList[0]
	for node in nodeList:
		lowest_node = node if node.f < lowest_node.f else lowest_node

	return lowest_node

func is_goal(node, goal):
	return node.x == goal.x and node.y == goal.y

func get_neighbours(grid, node):
	var neighbours = []
	var localOffsets = [[1,0], [-1,0], [0,1], [0,-1]]
	for i in range(4):
		var coords = [node.x + localOffsets[i][0],node.y + localOffsets[i][1]]
		if  0 <= coords[0] and coords[0] <= grid[0].size()-1 and 0 <= coords[1] and coords[1] <= grid.size()-1:
			neighbours.append(grid[coords[0]][coords[1]])
	return neighbours

func tracePath():
	pass

func astar(grid, src, goal):
	var openList = []
	src.f = 0
	src.g = 0
	src.h = 0
	src.parent = src
	openList.append(src)

	var foundGoal = false

	while openList.size() > 0:
		var node = get_lowest_f(openList)
		openList.remove_at(openList.find(node))
		node.isClosed = true

		var neighbours = get_neighbours(grid, node)

		for neighbour in neighbours:
			if neighbour.isClosed:
				continue

			if is_goal(neighbour, goal):
				neighbour.parent = node
				tracePath()
				return


func _ready():
	if not checkIsValid():
		isValid = false
		print("The source or the goal is out of range.")
	if SOURCE == GOAL:
		isValid = false
		print("The source and the goal are in the same location.")
	if isValid:
		create_grid()
		addObstacles()
		var src_node = grid[SOURCE.x][SOURCE.y]
		var goal_node = grid[GOAL.x][GOAL.y]
		src_node.modulate = Color(0,1,0)
		src_node.isObstacle = false
		goal_node.modulate = Color(1,0,0)
		goal_node.isObstacle = false
		astar(grid, src_node, goal_node)
