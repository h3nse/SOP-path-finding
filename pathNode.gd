extends Sprite2D

var x
var y
const gridSpace = 5

func init(x, y):
	self.x = x
	self.y = y
	position = Vector2(x, y) * (scale.x + gridSpace) + Vector2(scale.x, scale.y) / 2
	CanvasModulate

func _ready():
	pass

func _process(delta):
	pass
