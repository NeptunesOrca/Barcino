extends Control
class_name DraggableObject
## The base class for any object that can be dragged around a layout. Extended by things such as tables, chairs, etc.
##
## This is the base class for objects that are draggable, such as tables, chairs, speakers, etc.
## NOTE: for this system to work, the layout layer has to be the same or greater than the menu layer. Otherwise, won't be able to pick up objects from the layout
## [br]NOTE: for this system to work, the menu layer has to be the same or greater as the layout layer. Otherwise, won't be able to pick up objects from the menu
## i.e. The menu and layout have to have the same layer value

# needed groupnames
#menuGroupName -> ControlMenu.groupName
#layoutHandlerGroupName -> VenueController.groupName
#layoutGroupName -> Venue.layoutGroupName

#region Member Variables
#region Key Nodes
## The [ControlMenu]
var menu : ControlMenu
## The [SelectionMenu]
var selectionMenu : SelectionMenu
## The [Container] within the object menu tab that this [DraggableObject] is held within.
## [br]This [Container] determines the position within the object menu of the [DraggableObject] for the user to drag it onto a [Venue]
var menuParentNode : Container
## The [VenueController]
var layoutHandler : VenueController
## The current layout, i.e. [Venue] that the object will be added to
var layout : Venue
#endregion

#region Internal Binary Properties
## Used when a [DraggableObject] is dragged, indicates whether it started within the object menu or if it was already on a layout
var startedInMenu : bool
## Used when inputs occur (as handled by [method _input] and [method _on_gui_input]) , indicates whether the [DraggableObject] is currently undergoing a drag movement
var dragging : bool
##Used when starting a drag movement on a [DraggableObject] to prevent certain actions from occurring multiple times, indicates whether the [DraggableObject] has done the initial drag effects or not
var dragStarted : bool = false
##Used when a [DraggableObject] is selected and/or deselected for the [SelectionMenu], indicates when the object has been selected
var selected : bool = false
#endregion

#region Internal Menu Properties
## Used when a [DraggableObject] is dragged out of the menu, to adjust where the object is finally placed on the [Venue]
var menuOffset : Vector2
#endregion

#region Internal Layout Properties
## An enumeration for clarity within the code
enum LayoutExists {FALSE, TRUE}
#endregion

#region Object Properties for Selection
#region Property Lists
## An array that stores every defined [SelectionProperty] for the [DraggableObject]. Used to generate the [member propertyFieldList].
var propertyList = []
## A [Dictionary] that stores each [SelectionPropertyField] generated from the [member propertyList] when the [DraggableObject] is selected by the [SelectionMenu]
## [br] Each [SelectionPropertyField] corresponds to an entry in the [member selectionMenu] that can be used to adjust or display various aspects of the [DraggableObject]
## [br] For each [SelectionProperty] in the [member propertyList], [member propertyList] stores the [member SelectionProperty.name] as the key and a reference to each [SelectionPropertyField] as the value
var propertyFieldList = {}
#endregion

#region General Properties
const genpropheader = "General Properties"
var genpropheaderprop = HeaderProperty.new(genpropheader)
var typeName : String
var editableName : EditableTextProperty
var typeNameProp : DisplayTextProperty
var genpropsep = SeperatorProperty.new(genpropheader + " seperator")
var genprops
#endregion

#region Positional Properties,
const posHeader = "Positional Properties"
#var posheaderprop = HeaderProperty.new(posHeader)
const positionUnits = ""
var xprop = NumericEntryProperty.new("X","setX",self.position.x,NumericEntryProperty.NO_MINIMUM,NumericEntryProperty.NO_MAXIMUM,2,"",positionUnits)
var yprop = NumericEntryProperty.new("Y","setY",self.position.y,NumericEntryProperty.NO_MINIMUM,NumericEntryProperty.NO_MAXIMUM,2,"",positionUnits)
const rotUnits = "°"
var rotationprop = NumericEntryProperty.new("Rotation","setRotation",self.rotation_degrees,NumericEntryProperty.NO_MINIMUM,NumericEntryProperty.NO_MAXIMUM,1,"",rotUnits)
var possep = SeperatorProperty.new(posHeader + "seperator")
var posprops = [xprop, yprop, rotationprop, possep]
#endregion
#endregion
#endregion

#region Class Initialization
## Class Initialization. Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "DraggbleObject", but can be overridden by subclasses.
func _init(typeName : String = "DraggableObject"):
	editableName = EditableTextProperty.new("Name","setName",typeName)
	typeNameProp = DisplayTextProperty.new("Object Type", typeName)
	genprops = [genpropheaderprop, editableName, typeNameProp, genpropsep]
	collectProperties()
	setRotationPoint()

## Collects all the [SelectionProperty]s to be put in the [member propertyList] during [method _init].
func collectProperties():
	propertyList.append_array(genprops)
	propertyList.append_array(posprops)

## Sets the point the [DraggableObject] should rotate around. Defaults to the centre, but can be overridden by subclasses
## [br] Used during [method _init].
## [br][br] See [method Control.set_anchors_preset], and [enum Control.LayoutPreset.PRESET_CENTER]
func setRotationPoint():
	set_anchors_preset(Control.PRESET_CENTER)
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
## [br]Runs all the required finder functions to prepare the [DraggableObject] for use.
## [br]When running [method findAllKeyNodes], calls it as deferred to ensure that all of the Key Nodes have a chance to properly add themselve to the correct groups before trying to find them
func _ready() -> void:
	call_deferred("findAllKeyNodes") #Deferred until after first frame to ensure that all of the Key Nodes have a chance to get themselves in the right groups
	self.gui_input.connect(_on_gui_input)

#region Finder Functions
## Function that collects all the finders together for when we want to do all of them at once.
## When called in [method _ready], to be deferred until after first frame, to ensure that all of the Key Nodes have a chance to add themselves to the appropriate groups before this occurs
func findAllKeyNodes():
	findMenu()
	findSelectionMenu()
	findLayoutHandler()
	findLayout() #should probably yeet this
	findMenuParent()

## Generic function that returns a specific [Node] from the tree, using the specified [param groupName].
func finder(groupName : String) -> Node:
	return get_tree().get_first_node_in_group(groupName)

## A finder function for the [VenueController]
func findLayoutHandler():
	layoutHandler = finder(VenueController.groupName)

#region Finding the Layout and what to do if no Layout Found
## A finder function for the [member layout] 
func findLayout():
	if (layoutHandler == null):
		findLayoutHandler()
	
	if (layoutHandler.hasLayoutSelected()):
		layout = layoutHandler.getActiveLayout()
		return LayoutExists.TRUE
		#early return, no more work to do
	
	noLayoutFound()
	return LayoutExists.FALSE

## An internal class that simply tells the user that they must select a [Venue] for [member layout] before they can start modifying or using [DraggableObjects].
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
		self.queue_free()

## A function that determines what to do if no [member layout] has been found for the [DraggableObject] to use.
## Helps the user find where to select a [Venue] for [member layout], and uses the [noLayoutPopup] to tell the user to select a [Venue] before trying to use the [DraggableObjects].
## If the [DraggableObject] is currently invisible, does nothing, as the user is clearly not trying to interact with it.
func noLayoutFound():
	# If the object is not visible, does nothing. The user clearly isn't trying to interact with it if it's invisible.
	# The second half of this is a little bit janky, but it'll get the job done
	if ((not visible) || (menu.current_tab != ControlMenu.TabNumber.OBJECTS_TAB)):
		return
	
	if (menu == null):
		findMenu()
	
	#Switch to layouts tab in menu
	menu.switchMenuTab(ControlMenu.TabNumber.VENUES_TAB)
	
	#NOTE: Optional feature: highlight the venue selection area
	
	#Throw a popup for the user to tell them to select a layout
	noLayoutPopup.new(menu)
#endregion

#region Menu and Menu Features
## A finder function for the [member menu]
func findMenu():
	menu = finder(ControlMenu.groupName)

## Locates the [member menuParentNode] for use in creating new objects.
## [br]Intended to be called while in the Object Menu before it is dragged, not after. Will throw an error if called while a [DraggableObject] is inside a [Venue].
## [br]Throws an error if an appropriate [member menuParentNode] cannot be found.
func findMenuParent():
	if (self.get_parent() is Container):
		menuParentNode = self.get_parent()
	else:
		var error_msg = "The menu parent node of " + str(self) + " is " + str(self.get_parent()) + ", a " + str(self.get_parent().get_class()) + ", not a Container"
		ErrorHandler.newError(error_msg)
#endregion

## A finder function for the [member selectionMenu] TODO
func findSelectionMenu():
	selectionMenu = finder(SelectionMenu.groupName)
#endregion
#endregion

#region Checks
## Checks if the [member layout] selected is valid, and returns the result as a bool
func checkLayout() -> bool:
	var validLayout = false
	#check that layout exists, is a venue, and is visible
	if (layout != null && layout is Venue && layout.is_visible()):
		validLayout = true
	#otherwise, try to find a valid layout
	else :
		validLayout = findLayout()
	return validLayout

## Checks if the [DraggableObject] is currently inside one of the Deletion Areas (i.e. a location that does not make sense and that the [DraggableObject] should be deleted if it's in), and returns the result as a bool.
## [br]The currently specified Deletion Areas are:
## [br] - Outside the program window
## [br] - The Object Menu/Venue Controller menu
## [br] - The Selection Menu
func inDeletionArea() -> bool:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	
	# If you drag an object to back inside the menu, that is an invalid spot
	# So the Object Menu is a deletion area
	if (menu.isInside(mouse_pos)):
		return true
	
	#The Selection Menu is a deletion area
	if (selectionMenu.isInside(mouse_pos)):
		return true
	
	# Outside of the program's screen is a deletion area
	if (not viewport.get_visible_rect().has_point(mouse_pos)):
		return true
	
	# No invalid spot has been found that the object is in, so it did not end in a deletion area
	return false
#endregion

#region GUI Input
#region Main GUI Functions
## The main function that controls and handles GUI input.
## [br]Handles clicks, the start of any drag, etc.
func _on_gui_input(event):
	#region Ensure that the menu, selection menu, and layout have been properly set
	if menu == null:
		findMenu()
	if (not checkLayout()):
		return #ALERT: a valid layout has not been found, let findLayout() throw an error, skip rest of function
	if (selectionMenu == null):
		findSelectionMenu()
	#endregion
	
	# Tracks when an object is clicked, i.e. when it is first picked up
	# If there hasn't been a click, then there's no way that there's been a drag or selection
	if Input.is_action_just_pressed("LClick"):
		#Set whether the object started within the objects menu or not
		startedInMenu = menu.isInside(get_viewport().get_mouse_position())
		
		#Anytime there is a click on an object, we select it.
		#The original version of selection in testing decided that objects wouldn't be selected if they were dragged
		#This has been changed because a) it's easier, and b) it gives more functionality to the user, who can go straight from dragging an object to adjusting it's properties
		#Generally, if a user drags an object, that's going to be the object they're most likely to change the properties of, and in the worst case they have to make one more click in the edge cases where they'd rather adjust whatever they had previously selected
		#The selection menu will later call select() on this object
		#This ensures that the selection menu is still in control of when properties are added and removed, as well as which object is selected at which time
		#We also add a check to make sure we aren't wasting time and resources by selecting objects that are already selected
		if (not selected):
			selectionMenu.select(self)
		
	#region Perform the drag
	if (event is InputEventScreenDrag):
		#Drag the DraggableObject along with the mouse
		self.position += event.relative
		dragging = true
		
		# This is for anythings that we want to do exactly once per drag (i.e. any initial setup)
		if not dragStarted:
			# This is for anything that only happens for when the drag starts within the Menu (i.e. this is a new object)
			if startedInMenu:
				# Reparent object to the layout, so that the ScrollContainer for the Object Menu won't clip it during the drag
				# Ensure that the menuParent is not changed during this for duplication at the end of the drag
				putInLayout()
			dragStarted = true
	#endregion

## Built-in function that is called every time there is an input for this object
## [br]Calls [method handleDragEndLogic]
func _input(_event):
	handleDragEndLogic()

## Does any required finishing work for when a drag ends. Called when an event is passed to [method _input].
## Does nothing if a drag is not ending, i.e. if [member dragging] is false or if a left click has not just been released
func handleDragEndLogic():
	# Ignore anything that isn't the end of a drag
	if ( not (dragging && Input.is_action_just_released("LClick")) ):
		return
	
	# For objects that have been pulled from the menu
	if startedInMenu:
		if (menuParentNode == null):
			findMenuParent()
		repopulateMenu()
	
	# Delete objects that end their drag in invalid locations
	if (inDeletionArea()):
		queue_free()
		return
	
	#The drag is over, make sure we return the invarient to such a state that it is ready for next time
	dragging = false
	dragStarted = false
	
	#Update the selectionMenu properties to match the final position
	updatePositionPropertyFields()
#endregion

#region Selection and Deselection
## Selects the [DraggableObject], and also generates every [SelectionPropertyField] from [member propertyList]
## [br] Each [SelectionPropertyField] is added to [member propertyFieldList] and also to the [member selectionMenu]
func select():
	if selected:
		return
	
	#Generate Property Fields
	var newfield
	for property in propertyList:
		if property == null: #skip null properties, just don't bother trying to display them. We assume this is intentional by the programmer, and do not throw an error popup.
			push_error(property, " in ", self, " is null. Is this intentional?")
			continue
		newfield = property.generate(self)
		selectionMenu.addPropertyField(newfield)
		propertyFieldList[property.name] = newfield
	
	selected = true

## Deselects the [DraggableObject]. The destruction of the [PropertyField]s is handled by [method SelectionMenu.deselect], so that it has control over its children.
## [br][br]It's possible that it would be better to generate all the [SelectionPropertyField]s, and then just remove them as children of the parent, having them hide in memory somewhere.
## [br]The advantage would be that we aren't regenerating and deleting things very often, but the disadvantage is that we have a bunch of memory being taken up by things that might not be seen again.
## [br]If selection is taking a very long time, consider an alternative implementation.
func deselect():
	selected = false
	
	#empty the list so we don't have keys that correspond to previous references
	propertyFieldList.clear()
#endregion

#region Adjustments for when starting within a menu
#region Pre-Drag Adjustments
## Performs all the functions needed to put a [DraggableObject] inside the [member layout] instead of still being in the menu
func putInLayout():
	adjustMenuOffsets()
	adjustTransformLocationForLayout()
	changeOwnerToLayout()

## Adjusts the position of the [DraggableObject] so that when it enters the [member layout], it will be in the same position relative to the mouse
func adjustMenuOffsets():
	var mouse_pos = get_viewport().get_mouse_position()
	#menuOffset = self.get_local_mouse_position() is consistent, but doesn't move it by enough
	#menuOffset = smouse_pos moves it all over the place
	#scaling self.get_local_mouse_position() by self.size makes everything worse
	var parent = self.get_parent()
	if (parent == null || (not (parent is Container)) ):
		#Somehow this DraggableObject doesn't have a parent
		var error_msg = "DraggableObject " + str(self) + " does not have a parent."
		ErrorHandler.newError(error_msg)
	else:
		# For reasons I don't fully understand, the global position of the parent does not matter, despite the position within the parent mattering
		var positionWithinParent = parent.get_local_mouse_position()
		# The direction of the subtraction could be reversed, but this keeps the form self.position -= offset consident with other offset changes
		menuOffset = positionWithinParent - mouse_pos
	#account for the position the object was pulled from in the menu
		
	self.position.x -= menuOffset.x
	self.position.y -= menuOffset.y

## Adjusts the position of the [DraggableObject] so that when it enters the [member layout], it's dropped position will be the same relative to the scale of the [Venue]
func adjustTransformLocationForLayout():
	var layoutOffset = layout.get_offset()
	var layoutScale = layout.get_scale()
	
	#account for layout offset from the mouse position
	self.position.x -= layoutOffset.x
	self.position.y -= layoutOffset.y
	#account for layout scale
	self.position.x /= layoutScale.x
	self.position.y /= layoutScale.y

## Changes Ownership of the [DraggableObject], making it a child node of the [member layout], instead of [member menuParentNode] or some other descendant of [member menu].
func changeOwnerToLayout():
	#deparent the object so that is can be added as a child to something else
	#we could use menuParentNode, but this is more reliable, as it will work no matter what structure we have, whether it's the same or not
	self.get_parent().remove_child(self)
	# make the object a child of the layout
	layout.add_child(self)
#endregion

#region Post-Drag Adjustments
## Places a copy of this [DraggableObject] in the [member menu] so that another one can be added
func repopulateMenu():
	checkLayout()
	#recreate @ start location in menu
	var copiedNode : DraggableObject = self.duplicate()
	menuParentNode.add_child(copiedNode)
	copiedNode.findMenuParent()
#endregion
#endregion
#endregion

#region Properties Adjustment
#region General Properties
## Sets the [member Node.name] of the [DraggableObject], for the user to customize.
## [br] Used by the [PropertyField] corresponding to [member editableName]
func setName(text : String):
	self.name = text
	editableName.defaultText = text
#endregion

#region Positional Properties
## Manually sets the X-value of the [member Control.position] of the object.
## [br] Used by the [PropertyField] corresponding to [member xprop]
func setX(x : float):
	self.position.x = x
	xprop.defaultValue = x

## Manually sets the Y-value of the [member Control.position] of the object.
## [br] Used by the [PropertyField] corresponding to [member yprop]
func setY(y : float):
	self.position.y = y
	yprop.defaultValue = y

## Sets the [member Control.rotation_degrees] of the object.
## [br] Used by the [PropertyField] corresponding to [member rotationprop]
func setRotation(angle : float):
	self.rotation_degrees = angle
	rotationprop.defaultValue = angle

## Updates [member xprop], [member yprop], and any corresponding [PropertyField]s to match the accurate [member Control.position] of the [DraggableObject]
## [br] Used by [method handleEndDragLogic] when the drag ends.
func updatePositionPropertyFields():
	var currentPosition = self.position
	xprop.defaultValue = currentPosition.x
	yprop.defaultValue = currentPosition.y
	
	if selected:
		var xpropfield = propertyFieldList[xprop.name]
		var ypropfield = propertyFieldList[yprop.name]
		xpropfield.updateValueNoSignal(currentPosition.x)
		ypropfield.updateValueNoSignal(currentPosition.y)
#endregion
#endregion

#region Close Up
## Overridden from [Node]. Called whenever the [DraggableObject] is about to leave the [SceneTree] (specifically, when removed as a child with [method Node.remove_child] or when freed (deleted) such as by [method Node queue_free]).
## [br] Ensures that the [DraggableObject] [deselect]s itself (also see [method selectionMenu.deselect]) before it's deleted by [method Node.queue_free] or similar.
func _exit_tree() -> void:
	# We don't want to deselect the object if it is pulled from the menu
	# However, if we don't check for it, it will be automatically deselected because we call remove_child on it to remove it from the Objects Menu and add it to the layout
	# So we use startedInMenu to check for this.
	# If there was some other reason the draggable object was removed from the tree but not deleted, we would want to ensure that we were excluding that case as well
	if not startedInMenu:
		selectionMenu.deselect() #since the selectionmenu handles the the propertyfields as it's own descendants, we want to ensure that it is managing that
#endregion
