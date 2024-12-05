extends TextureRect


# Declare member variables here. Examples:

# Static nodes
var menu # the main objects Menu panel
var layout # the layout

# Binary properties
var startedInMenu
var dragging

# to conserve space, we create the variables here
var viewport
var mouse_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	findMenu()

func findMenu():
	menu = get_tree().get_first_node_in_group("ObjectsMenu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TestObjApproach2_gui_input(event):
	print("Interaction with test object")
	if menu == null:
		print("Setting menu")
		findMenu()
		
	if Input.is_action_just_pressed("LClick"):
		startedInMenu = menu.isInside(get_viewport().get_mouse_position())
	
	if event is InputEventScreenDrag:		
		rect_position += event.relative
		dragging = true

func _input(_event):
	if (dragging && Input.is_action_just_released("LClick")):
		if startedInMenu:
			#recreate @ start location in menu
			var copiedNode = self.duplicate()
			menu.add_child(copiedNode)
			copiedNode.rect_position = Vector2(20,20)
			
			
		viewport = get_viewport()
		mouse_pos = viewport.get_mouse_position()
		if (menu.isInside(mouse_pos) || (!viewport.get_visible_rect().has_point(mouse_pos))):
			queue_free() #delete the object
			
		dragging = false
