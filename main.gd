extends PathFinding

@export var tickSpeed = 0.02
@export var rerunDelay = 2
@export_group("Grid")
@export var grid_dimensions = Vector2(25,25)
@export var source = Vector2(0,0)
@export var destination = Vector2(25,25)
@export_range(0,100) var obstacle_ratio = 30

const NODESPACE = 35

const _grid = preload("res://Grid.tscn")
const _aStar = preload("res://Astar.tscn")
const _bfs = preload("res://bfs.tscn")

func _ready():
	var aStar = _aStar.instantiate()
	var bfs = _bfs.instantiate()
	aStar.add_to_group("Algorithms")
	bfs.add_to_group("Algorithms")
	add_child(aStar)
	add_child(bfs)

	var grid = _grid.instantiate()
	grid.init(grid_dimensions)
	aStar.init(grid , source, destination)
	grid = _grid.instantiate()
	grid.init(grid_dimensions)
	bfs.init(grid, source, destination)
	$Rerun.start(rerunDelay)

func _on_rerun_timeout():
	var newGrid = get_new_grid(grid_dimensions, obstacle_ratio)
	for child in get_children():
		if child.is_in_group("Algorithms"):
			child.grid.set_obstacles(newGrid)

