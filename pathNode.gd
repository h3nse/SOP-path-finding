extends Sprite2D

var x
var y
const gridSpace = 5
var isObstacle: bool = false:
	set(new_value):
		isObstacle = new_value
		if isObstacle:
			modulate = Color.BLACK

func init(_x, _y):
	x = _x
	y = _y
	position = Vector2(x, y) * (scale.x + gridSpace) + Vector2(scale.x, scale.y) / 2

func _ready():
	pass

func _process(delta):
	pass
