extends PathFinding

@export var tickSpeed = 0.02
@export var rerunDelay = 2
@export_group("Grid")
@export var grid_dimensions = Vector2(25,25)
@export var source = Vector2(0,0)
@export var destination = Vector2(24,24)
@export_range(0,100) var obstacle_ratio = 30

@onready var aStar = $Astar
@onready var bfs = $Bfs
@onready var algorithms = [aStar, bfs]

# Benchmarking
var bfsFound = false
var aStartFound = false
var bfsResults = []
var aStarResults = []

var time = 0
const NODESPACE = 35

func _ready():
	for a in algorithms:
		a.init(grid_dimensions, source, destination)

	$Rerun.start(rerunDelay)

func _on_rerun_timeout():
	time = 0
	if bfsFound and aStartFound: # Benchmarking
		grid_dimensions += Vector2(1,1) # Benchmarking
		destination += Vector2(1,1) # Benchmarking
		bfsResults.append(float(algorithms[1].time.text)) # Benchmarking
		aStarResults.append(float(algorithms[0].time.text)) # Benchmarking
	var newGrid = get_new_grid(grid_dimensions, obstacle_ratio)
	for a in algorithms:
		a.init(grid_dimensions, source, destination) # Benchmarking
		a.reset(newGrid)
	if destination == Vector2(25,25): # Benchmarking
		print("BFS results:")
		print(bfsResults)
		print("\n")
		print("A* results:")
		print(aStarResults)
		return
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

func _on_astar_done(foundDest):
	aStar.get_child(1).text = String.num(time, 2)
	algorithms.pop_front()
	aStartFound = foundDest # Benchmarking


func _on_bfs_done(foundDest):
	bfs.get_child(1).text = String.num(time, 2)
	algorithms.pop_back()
	bfsFound = foundDest # Benchmarking
