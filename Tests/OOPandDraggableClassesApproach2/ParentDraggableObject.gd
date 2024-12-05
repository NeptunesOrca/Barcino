extends Control
class_name ParentDraggableObject


# Group Names
export var menuGroupName = "ObjectsMenu"
export var layoutGroupName = "Layout"

# Static nodes
var menu # the main objects Menu panel
var layout # the layout

# Binary properties
var startedInMenu
var dragging

# Menu Location
var menuLocation: Vector2
export var defaultMenuX : = 20
export var defaultMenuY : = 20
var defaultMenuLocation = Vector2(defaultMenuX,defaultMenuY) #= Vector2(20,20)

func _init(startX := defaultMenuX, startY := defaultMenuY):
	menuLocation = Vector2(startX, startY)

# Called when the node enters the scene tree for the first time.
func _ready():
	findMenu()

func findMenu():
	menu = get_tree().get_first_node_in_group(menuGroupName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ParentDraggableObject_gui_input(event):
	print("Interaction with object at ", menuLocation)
	
	# Ensure that the menu has been set
	if menu == null:
		findMenu()
		
	# Set whether the object stared within the objects menu or not
	if Input.is_action_just_pressed("LClick"):
		startedInMenu = menu.isInside(get_viewport().get_mouse_position())
	
	# Drag the DraggableObject along with the mouse
	if event is InputEventScreenDrag:		
		rect_position += event.relative
		dragging = true

# Handles various inputs to the DraggableObject
func _input(_event):
	handleDragLogic()
		
func handleDragLogic():
	# Handling the end of a drag
	if (dragging && Input.is_action_just_released("LClick")):
		# Since the objects are pulled from the menu, the first thing to do is to repopulate the menu
		if startedInMenu:
			repopulateMenu()
		
		# If the object is ends its drag in a invalid location, delete the object
		if (endedInDeletionArea()):
			queue_free()
		
		# The drag has ended
		dragging = false

func repopulateMenu():
	#recreate @ start location in menu
	var copiedNode = self.duplicate()
	menu.add_child(copiedNode)
	copiedNode.rect_position = Vector2(20,20)
	
# Tests if a drag finishes with the object inside a deletion area
func endedInDeletionArea() -> bool:
	# The Objects Menu is a deletion area
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	if (menu.isInside(mouse_pos)):
		return true
		
	# Outside of the program's screen (viewport) is a deletion area
	if (!viewport.get_visible_rect().has_point(mouse_pos)):
		return true

	# The drag did not end inside any deletion areas, so return false
	return false
