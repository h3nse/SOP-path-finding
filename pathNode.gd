extends Sprite2D

const gridSpace = 5

var isSrc = false:
	set(new_value):
		isSrc = new_value
		if isSrc:
			modulate = Color.GREEN
var isDest = false:
	set(new_value):
		isDest = new_value
		if isDest:
			modulate = Color.RED
var isObstacle = false:
	set(new_value):
		if not(isSrc or isDest):
			isObstacle = new_value
			if isObstacle:
				modulate = Color.BLACK
var isCurrent = false:
	set(new_value):
		if not(isSrc or isDest):
			isCurrent = new_value
			if isCurrent:
				modulate = Color.BLUE_VIOLET
			elif isClosed:
				modulate = Color.ORANGE
var isClosed = false:
	set(new_value):
		isClosed = new_value
		if isClosed and not(isSrc or isDest):
			isCurrent = false
			modulate = Color.ORANGE
var parent: Object
var x: int
var y: int
var g: int
var h: int
var f: int

func init(_x, _y):
	x = _x
	y = _y
	position = (Vector2(y, x) * (scale.x + gridSpace)
	+ Vector2(scale.x, scale.y) / 2 + Vector2(gridSpace, gridSpace))

func reset():
	isClosed = false
	if not(isSrc or isDest):
		isObstacle = false
		isCurrent = false
		modulate = Color.WHITE
