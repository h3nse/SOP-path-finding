extends Node2D

enum Algorithm {Astar, Bfs}
@export var algorithm: Algorithm

const aStar = preload("res://Astar.tscn")
const bfs = preload("res://bfs.tscn")

func _ready():
	match algorithm:
		Algorithm.Astar:
			add_child(aStar.instantiate())
		Algorithm.Bfs:
			add_child(bfs.instantiate())
