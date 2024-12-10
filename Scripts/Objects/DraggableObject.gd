extends Control
class_name DraggableObject
## The base class for any object that can be dragged around a layout. Extended by things such as tables, chairs, etc.
##
## 

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
#endregion

#region Binary Properties
## Used when a [DraggableObject] is dragged, indicates whether it started within the object menu or if it was already on a layout
var startedInMenu : bool
## Used when ????, indicates whether the [DraggableObject] is currently undergoing a drag movement
var dragging : bool
#endregion

#region Menue
## The [Container] within the object menu tab that this [DraggableObject] is held within.
## [br]This [Container] determines the position within the object menu of the [DraggableObject] for the user to drag it onto a [Venue]
var menuParentNode : Container
## Used when a [DraggableObject] is dragged out of the menu, to adjust where the object is finally placed on the [Venue]
var menuOffset : Vector2
#endregion

#region Layout
## The current layout, i.e. [Venue] that the object will be added to
var layout
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
		#NOTE: Error handling goes here
#endregion
#endregion
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
