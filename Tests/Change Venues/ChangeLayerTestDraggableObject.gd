extends Control
class_name ChangeLayerTestDraggableObject

# Group Names
export var menuGroupName = "ObjectsMenu"
export var layoutHandlerGroupName = "LayoutHandler"
export var layoutGroupName = "ActiveLayout"

# Static nodes
var menu # the main objects Menu panel
var layoutHandler # the layout handler/venue selector
var error_handler # the error handler, in case it is needed

# Binary properties
var startedInMenu
var dragging

# Menu
var menuParentNode : Container
var menuOffset : Vector2

# Layout
var layout # the layout

enum LayoutExists {FALSE, TRUE}

# Called when the node enters the scene tree for the first time.
func _ready():
	findMenu()
	findLayoutHandler()
	findLayout()
	findMenuParent()

func findMenu():
	menu = get_tree().get_first_node_in_group(menuGroupName)

func findLayoutHandler():
	layoutHandler = get_tree().get_first_node_in_group(layoutHandlerGroupName)

func findLayout() -> bool:	
	if (layoutHandler == null):
		findLayoutHandler()
	# Check that a layout has been selected
	if (layoutHandler.hasLayoutSelected()):
		layout = layoutHandler.getActiveLayout()
		return LayoutExists.TRUE #early return, no more work to do
	
	noLayoutFound()
	
	return LayoutExists.FALSE

# Inner class for the user's popup for unselected layout
class noLayoutPopup extends AcceptDialog:
		func _init(attachingNode : Node):
			# Properties
			self.window_title = "No Venue Selected!"
			self.dialog_text = "Please select a venue to add this object to."
			self.popup_exclusive = true
			# Add to tree under whatever node it is supposed to attach to, temporarily
			attachingNode.add_child(self)
		func _ready(): # pops up when created
			self.popup_centered()
			self.connect("confirmed",self,"_on_confirmed")
		func _on_confirmed(): # deletes itself once finished
			self.queue_free()

func noLayoutFound():
	# Switch to menu tab
	if (menu == null):
		findMenu()
	menu.switchMenuTab(Menu.TabNumber.VENUES_TAB)
	
	#Optional feature: highlight venue selection
	
	# Throw an error popup for the user
	noLayoutPopup.new(menu)
	
func checkLayout() -> bool:
	var validLayout = false
	# check that layout exists, is a venue, and is visible
	if (layout != null && layout is Venue && layout.is_visible()):
		validLayout = true
		return validLayout # early return
	
	validLayout = findLayout()
	return validLayout

func findMenuParent():
	if (self.get_parent() is Container):
		menuParentNode = self.get_parent()
	else:
		var error_msg = "The menu parent node of " + str(self) + " is " + str(self.get_parent()) + ", a " + str(self.get_parent().get_class()) + ", not a Container"
		ErrorHandler.newError(self, error_msg)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TestDraggableObject_gui_input(event):	
	# Ensure that the menu and layout have been set
	if menu == null:
		findMenu()
	if (not checkLayout()):
		return # a valid layout has not been found, let the findLayout() function throw an error and skip the rest of the function

	# This tracks when the object is clicked, that is, when it is first picked up
	if Input.is_action_just_pressed("LClick"):
		# Set whether the object started within the objects menu or not
		startedInMenu = menu.isInside(get_viewport().get_mouse_position())
		# If the object started within the menu, we have some behaviours to adjust before dragging
		if (startedInMenu):
			adjustScaleToMatchLayout()
			calculateMenuOffsets()
	
	# Drag the DraggableObject along with the mouse
	if event is InputEventScreenDrag:
		rect_position += event.relative
		dragging = true

# Handles various inputs to the DraggableObject
func _input(_event):
	handleDragLogic()

# When an object is picked up from the menu, we want it to match the size it will be in the layout, not the size it is within the menu
func adjustScaleToMatchLayout():
	self.rect_size *= layout.get_scale()

# Undoes adjustScaleToMatchLayout() as required
func revertScaleFromLayout():
	self.rect_size /= layout.get_scale()

# Calculates the offset the menu has from the layout
func calculateMenuOffsets():
	var mouse_pos = get_viewport().get_mouse_position()
	#menuOffset = mouse_pos # this doesn't work either, always drops the object's top-right corner where the mouse currently is instead of maintaining the relative position between mouse and object
	#menuOffset = mouse_pos - self.get_parent().get_rect().position # this doesn't work either
	#menuOffset = self.get_parent().get_rect().position # The menu parents are wacky now, so this isn't working
	menuOffset = mouse_pos - self.get_local_mouse_position()
	
func handleDragLogic():
	# Handling the end of a drag
	if (dragging && Input.is_action_just_released("LClick")):
		# Since the objects are pulled from the menu
		if startedInMenu:
			revertScaleFromLayout() # there may exist a bug somewhere in here that ends up changing the scale of the original at random
			repopulateMenu()
			putInLayout()
		
		# If the object is ends its drag in a invalid location, delete the object
		if (endedInDeletionArea()):
			queue_free()
			return
		
		# The drag has ended
		dragging = false

func repopulateMenu():
	checkLayout()
		
	#recreate @ start location in menu
	var copiedNode = self.duplicate()
	if (menuParentNode == null):
		findMenuParent()
	menuParentNode.add_child(copiedNode)
	
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
	
func putInLayout():
	changeOwnerToLayout()
	adjustTransformLocationForLayout()

func changeOwnerToLayout():
	# deparent the object so that it can be added as a child to something else
	self.get_parent().remove_child(self)
	# make the object a child of the layout
	layout.add_child(self)

# When we add objects to the layout, we modify them to work on the scale and translation of the layout, allowing us to change around the size and scale of the layout independent from the menu
func adjustTransformLocationForLayout():	
	var layoutOffset = layout.get_offset()
	var layoutScale = layout.get_scale()
	#var layoutRotationDegrees = layout.get_rotation_degrees() #adding compatibility with rotation will be a bonus feature later if there's time	
	
	# account the position the object was pulled from in the menu
	self.rect_position.x += menuOffset.x
	self.rect_position.y += menuOffset.y
	# account for offset by subtracting layout offset from mouse position
	self.rect_position.x -= layoutOffset.x
	self.rect_position.y -= layoutOffset.y
	# account for scale by dividing position by scale
	self.rect_position.x /= layoutScale.x
	self.rect_position.y /= layoutScale.y
	
	
### Note: for this system to work, the layout layer has to be the same or greater than the menu layer. Otherwise, won't be able to pick up objects from the layout
### Note: for this system to work, the menu layer has to be the same or greater as the layout layer. Otherwise, won't be able to pick up objects from the menu
### i.e. The menu and layout have to have the same layer value
