extends Node2D

enum Algorithm {Astar, Bfs, Both}
@export var algorithm: Algorithm

const _aStar = preload("res://Astar.tscn")
const _bfs = preload("res://bfs.tscn")
const _node = preload("res://bfsPathNode.tscn")

func _ready():
	match algorithm:
		Algorithm.Astar:
			add_child(_aStar.instantiate())
		Algorithm.Bfs:
			add_child(_bfs.instantiate())
		Algorithm.Both:
			add_child(_aStar.instantiate())
			var bfs = _bfs.instantiate()
			var node = _node.instantiate()
			bfs.position = Vector2(bfs.grid_dimensions.x * (node.scale.x + node.gridSpace) + 20,0)
			add_child(bfs)

