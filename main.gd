extends Node2D

@export_group("Grid")
@export_range(0,50,1,"or_greater") var ROWS = 10
@export_range(0,50,1,"or_greater") var COLS = 10
@export var SOURCE = Vector2()
@export var DESTINATION = Vector2(ROWS-1 , COLS-1)
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
	and DESTINATION.x >= 0 and DESTINATION.x < ROWS and DESTINATION.y >= 0 and DESTINATION.y < COLS)

func addObstacles():
	for x in range(grid.size()):
		for y in range(grid[x].size()):
			if randi_range(0,100) < OBSTACLE_RATION:
				grid[x][y].isObstacle = true

func _ready():
	if not checkIsValid():
		isValid = false
	if isValid:
		create_grid()
		addObstacles()
		grid[SOURCE.x][SOURCE.y].modulate = Color(0,1,0)
		grid[SOURCE.x][SOURCE.y].isObstacle = false
		grid[DESTINATION.x][DESTINATION.y].modulate = Color(1,0,0)
		grid[DESTINATION.x][DESTINATION.y].isObstacle = false


func _process(delta):
	pass
