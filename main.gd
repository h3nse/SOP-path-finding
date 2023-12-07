extends Node2D

@export var ROWS = 10
@export var COLS = 10
@export var SOURCE = Vector2()
@export var DESTINATION = Vector2(ROWS-1 , COLS-1)

var _node = preload("res://pathNode.tscn")

var grid = []

func create_grid(rows, cols):
	for x in rows:
		grid.append([])
		for y in cols:
			var node = _node.instantiate()
			node.init(x,y)
			grid[x].append(node)
			add_child(node)

func _ready():
	create_grid(ROWS, COLS)
	grid[SOURCE.x][SOURCE.y].modulate = Color(0,1,0)
	grid[DESTINATION.x][DESTINATION.y].modulate = Color(1,0,0)


func _process(delta):
	pass
