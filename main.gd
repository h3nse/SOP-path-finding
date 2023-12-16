extends PathFinding

@export var tickSpeed = 0.02
@export var rerunDelay = 2
@export_group("Grid")
@export var grid_dimensions = Vector2(25,25)
@export var source = Vector2(0,0)
@export var destination = Vector2(25,25)
@export_range(0,100) var obstacle_ratio = 30

@onready var aStar = $Astar
@onready var bfs = $Bfs
@onready var algorithms = [aStar, bfs]

var time = 0
const NODESPACE = 35

func _ready():
	for a in algorithms:
		a.grid.init(grid_dimensions)
		a.init(source, destination)

	$Rerun.start(rerunDelay)

func _on_rerun_timeout():
	time = 0
	var newGrid = get_new_grid(grid_dimensions, obstacle_ratio)
	for a in algorithms:
		a.reset()
		a.grid.set_obstacles(newGrid)
	$Tick.start(tickSpeed)

func _on_tick_timeout():
	time += tickSpeed
	$TimeLabel.text = String.num(time, 2)

	for a in algorithms:
		a.on_tick()
	if algorithms.size() > 0:
		$Tick.start(tickSpeed)
	else:
		algorithms = [aStar, bfs]
		$Rerun.start(rerunDelay)

func _on_astar_done():
	aStar.get_child(1).text = String.num(time, 2)
	algorithms.pop_front()

func _on_bfs_done():
	bfs.get_child(1).text = String.num(time, 2)
	algorithms.pop_back()
