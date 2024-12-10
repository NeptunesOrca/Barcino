extends Control
class_name DraggableObject
## The base class for any object that can be dragged around a layout. Extended by things such as tables, chairs, etc.
##
## This is the base class for objects that are draggable, such as tables, chairs, speakers, etc.
## NOTE: for this system to work, the layout layer has to be the same or greater than the menu layer. Otherwise, won't be able to pick up objects from the layout
## [br]NOTE: for this system to work, the menu layer has to be the same or greater as the layout layer. Otherwise, won't be able to pick up objects from the menu
## i.e. The menu and layout have to have the same layer value

# needed groupnames
#menuGroupName -> ControlMenu.objectMenuGroupName
#layoutHandlerGroupName -> VenueController.layoutHandlerGroupName
#layoutGroupName -> Venue.layoutGroupName

#region Member Variables
#region Key Nodes
## The [ControlMenu]
var menu : ControlMenu
## The [VenueController]
var layoutHandler : VenueController
## The [ScrollContainer] for the Objects Menu of of [menu]
@export var objectMenuScrollContainer : ScrollContainer
#endregion

#region Binary Properties
## Used when a [DraggableObject] is dragged, indicates whether it started within the object menu or if it was already on a layout
var startedInMenu : bool
## Used when ????, indicates whether the [DraggableObject] is currently undergoing a drag movement
var dragging : bool
#endregion

#region Menu Properties
## The [Container] within the object menu tab that this [DraggableObject] is held within.
## [br]This [Container] determines the position within the object menu of the [DraggableObject] for the user to drag it onto a [Venue]
var menuParentNode : Container
## Used when a [DraggableObject] is dragged out of the menu, to adjust where the object is finally placed on the [Venue]
var menuOffset : Vector2
#endregion

#region Layout Properties
## The current layout, i.e. [Venue] that the object will be added to
var layout : Venue
## An enumeration for clarity within the code
enum LayoutExists {FALSE, TRUE}
#endregion
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
## [br]Runs all the required finder functions to prepare the [DraggableObject] for use.
func _ready() -> void:
	findMenu()
	findLayoutHandler()
	findLayout()
	findMenuParent()
	self.gui_input.connect(_on_gui_input)

#region Finder Functions
## Generic function that returns a specific [Node] from the tree, using the specified [param groupName].
func finder(groupName : String):
	return get_tree().get_first_node_in_group(groupName)

## A finder function for the [VenueController]
func findLayoutHandler():
	layoutHandler = finder(VenueController.layoutHandlerGroupName)

#region Finding the Layout and what to do if no Layout Found
## A finder function for the layout, i.e. [Venue] 
func findLayout():
	if (layoutHandler == null):
		findLayoutHandler()
	
	if (layoutHandler.hasLayoutSelected()):
		layout = layoutHandler.getActiveLayout()
		return LayoutExists.TRUE
		#early return, no more work to do
	
	return LayoutExists.FALSE

## An internal class that simply tells the user that they must select a [Venue] before they can start modifying or using [DraggableObjects].
## [br]Essentially just an [AcceptDialog], but automatically deletes itself from memory once closed in any way.
class noLayoutPopup extends AcceptDialog:
	func _init(attachingNode : Node):
		#Properties
		self.title = "No Venue Selected!"
		self.dialog_text = "Please select a venue to add this object to."
		self.exclusive = true
		#Add to tree under whatever node it is supposed to attach to, temporarily
		attachingNode.add_child(self)
	func _ready(): #pops up when created
		self.popup_centered()
		self.confirmed.connect(_on_confirmed)
	func _on_confirmed():
		self.queue_free

## A function that determines what to do if no layout has been found for the [DraggableObject] to use
## Helps the user find where to select a [Venue], and uses the [noLayoutPopup] to tell the user to select a [Venue] before trying to use the [DraggableObjects]
func noLayoutFound():
	if (menu == null):
		findMenu()
	
	#Switch to layouts tab in menu
	menu.switchMenuTab(ControlMenu.TabNumber.VENUES_TAB)
	
	#NOTE: Optional feature: highlight the venue selection area
	
	#Throw an error opup for the user
	noLayoutPopup.new(menu)
#endregion

#region Menu and Menu Features
## A finder function for the [ControlMenu]
func findMenu():
	menu = finder(ControlMenu.objectMenuGroupName)

## Locates the [member menuParentNode] for use in creating new objects.
func findMenuParent():
	if (self.get_parent() is Container):
		menuParentNode = self.get_parent()
	else:
		var error_msg = "The menu parent node of " + str(self) + " is " + str(self.get_parent()) + ", a " + str(self.get_parent().get_class()) + ", not a Container"
		print(error_msg)
		#NOTE: Error handling goes here
#endregion
#endregion
#endregion

#region
## Checks if the [Venue] selected is valid, and returns the result as a bool
func checkLayout() -> bool:
	var validLayout = false
	#check that layout exists, is a venue, and is visible
	if (layout != null && layout is Venue && layout.is_visible()):
		validLayout = true
	#otherwise, try to find a valid layout
	else :
		validLayout = findLayout()
	return validLayout
#endregion

#region GUI Input
#region Main GUI Functions
## The main function that controls and handles GUI input.
## [br]Handles clicks, the start of any drag, etc.
func _on_gui_input(event):
	#region Ensure that the menu and layout have been properly set
	if menu == null:
		findMenu()
	if (not checkLayout()):
		return #ALERT: a valid layout has not been found, let findLayout() throw an error, skip rest of function
	#endregion
	
	# Tracks when an object is clicked, i.e. when it is first picked up
	# If there hasn't been a click, then there's no way that there's been a drag or selection
	if Input.is_action_just_pressed("LClick"):
		#region handle starting within the Objects Menu
		#Set whether the object started within the objects menu or not
		startedInMenu = menu.isInside(get_viewport().get_mouse_position())
		#If the object started within the menu, have have some behaviours to adjust before dragging
		if startedInMenu:
			adjustScaleToMatchLayout()
			calculateMenuOffsets()
		#endregion
		
	#region Perform the drag
	if (event is InputEventScreenDrag):
		#Drag the DraggableObject along with the mouse
		self.position += event.relative
		dragging = true
		
		# Reparent object to the menu, so that the ScrollContainer for the Object Menu won't clip it during the drag
		# Ensure that the menuParent is not changed during this
		if startedInMenu:
			adjustScaleToMatchLayout()
			calculateMenuOffsets()
			print("Dragging node: ",self)
			#objectMenuScrollContainer.clip_contents = false # this is super janky, I'd rather have something better
	#endregion

## Built-in function that is called every time there is an input for this object
## [br]Calls [method handleDragEndLogic]
func _input(_event):
	handleDragEndLogic()

func handleDragEndLogic():
	# Ignore anything that isn't the end of a drag
	if ( not (dragging && Input.is_action_just_released("LClick")) ):
		return
	
	# For objects that have been pulled from the menu
	if startedInMenu:
		#objectMenuScrollContainer.clip_contents = true #this is also super janky, I'd like to come up with something better but that can wait
		if (menuParentNode == null):
			findMenuParent()
		revertScaleFromLayout()
		putInLayout()
		repopulateMenu()
	
	# Delete objects that end their drag in invalid locations
	if (endedInDeletionArea()):
		queue_free()
		return
#endregion

#region Deletion Areas
func endedInDeletionArea() -> bool:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	
	# If you drag an object to back inside the menu, that is an invalid spot
	# So the Object Menu is a deletion area
	if (menu.isInside(mouse_pos)):
		return true
	
	# NOTE: The Selection Menu should be a deletion area too
	
	# Outside of the program's screen is a deletion area
	if (not viewport.get_visible_rect().has_point(mouse_pos)):
		return true
	
	# No invalid spot has been found that the object is in, so it did not end in a deletion area
	return false
#endregion

#region Adjustments for when starting within a menu
#region Pre-Drag Adjustments
func adjustScaleToMatchLayout():
	return
	self.size *= layout.get_scale()

func calculateMenuOffsets():
	return
	var mouse_pos = get_viewport().get_mouse_position()
	menuOffset = mouse_pos - self.get_local_mouse_position()
	#NOTE: This may need some rejiggering later
	
#endregion

#region Post-Drag Adjustments
func revertScaleFromLayout():
	return
	self.size /= layout.get_scale()

func putInLayout():
	changeOwnerToLayout()
	adjustTransformLocationForLayout()

func changeOwnerToLayout():
	#deparent the object so that is can be added as a child to something else
	#we could use menuParentNode, but this is more reliable, as it will work no matter what structure we have, whether it's the same or not
	self.get_parent().remove_child(self)
	# make the object a child of the layout
	layout.add_child(self)

func repopulateMenu():
	checkLayout()
	
	#recreate @ start location in menu
	var copiedNode : DraggableObject = self.duplicate()
	menuParentNode.add_child(copiedNode)
	copiedNode.findMenuParent()
	print("These nodes: ",self,copiedNode)
	print("Parents nodes: ",menuParentNode.get_children())

func adjustTransformLocationForLayout():
	return
	var layoutOffset = layout.get_offset()
	var layoutScale = layout.get_scale()
	
	#account for the position the object was pulled from in the menu
	self.position.x += menuOffset.x
	self.position.y += menuOffset.y
	#account for layout offset from the mouse position
	self.position.x -= layoutOffset.x
	self.position.y -= layoutOffset.y
	#account for layout scale
	self.position.x /= layoutScale.x
	self.position.y /= layoutScale.y
#endregion
#endregion
#endregion
