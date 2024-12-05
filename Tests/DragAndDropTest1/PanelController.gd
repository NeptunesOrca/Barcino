extends Panel


# Declare member variables here. Examples:
var menu # the main Menu panel

var currentlyDragging

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = get_node("%TestMenu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Panel_gui_input(event: InputEvent):
	if event is InputEventScreenDrag:
		rect_position += event.relative
		currentlyDragging = true

func _input(event: InputEvent):
	# Detect if Left Click is released within menu 
	if Input.is_action_just_released("LClick"):
		if (menu.isInside(event.position) && currentlyDragging):
			print("End of drag, inside menu")
		elif (menu.isInside(event.position)):
			print("Not dragging, inside menu")
		elif (currentlyDragging):
			print("End of drag, outside menu")
		else:
			print("Not dragging, outside menu")
		
		currentlyDragging = false			
