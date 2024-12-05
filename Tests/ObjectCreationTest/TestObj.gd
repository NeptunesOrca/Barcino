extends TextureRect


# Declare member variables here. Examples:
var selected
var dragging


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setPosition(position: Vector2):
	print("setPosition called")
	rect_position.x = position.x
	rect_position.y = position.y
	
func setSelected(val: bool):
	selected = val
	
func setDragging(val: bool):
	dragging = val
