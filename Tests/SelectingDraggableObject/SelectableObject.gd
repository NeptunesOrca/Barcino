extends DraggableObject
class_name SelectableObject

# Group Names
#export var menuGroupName = "ObjectsMenu"
#export var layoutGroupName = "ActiveLayout"
export var selectionMenuGroupName = "SelectionMenu"

# Static nodes
#var menu # the main objects Menu panel
#var layout # the layout
var selection_menu # the selection menu

# Binary properties
#var startedInMenu
#var dragging
var selected

# Menu
var menuParentNode : Container
var menuOffset : Vector2

#Test attributes
var diameter = 0
var width : int = 3
var length : int = 6
var shape = 0
enum linenStyle {
	NONE,
	WHITE,
	CREAM,
	BLACK,
	GREEN,
	}
const linenColour = {
	linenStyle.NONE : Color.transparent,
	linenStyle.WHITE : Color.white,
	linenStyle.CREAM : Color.wheat,
	linenStyle.BLACK : Color.black,
	linenStyle.GREEN : Color.forestgreen,
}
var linenType : int = linenStyle.NONE
var hasLinen : bool = false
var chairs : int = 0
var chairType : int = chairStyle.DIWAN
enum chairStyle {
	WHITE_FOLDING,
	BROWN_FOLDING,
	GREEN_FOLDING,
	DIWAN,
	OZAWA,
	IKOI_NO_BA,
}
var evenChairSpacing = true

# Properties
var propertyList = []

var generalHeadingProp = HeaderProperty.new("General Properties")
var objNameProp = TextFieldProperty.new("Name","","Diwan Rectangular "+"Table")
var widthDisplayProp = DisplayTextProperty.new("Width",str(width)+"'")
var lengthDisplayProp = DisplayTextProperty.new("Length",str(length)+"'")
var xProp = NumericFieldProperty.new("X","manuallyAdjustX", self.rect_position.x)
var yProp = NumericFieldProperty.new("Y","manuallyAdjustY", self.rect_position.y)
var rotationProp = NumericFieldProperty.new("Rotation","adjustRotation",0,NumericFieldProperty.NO_MINIMUM,NumericFieldProperty.NO_MAXIMUM,1,"","°")
var generalPropEnd = SeperatorProperty.new("General Properties End Line")
var generalProperties = [generalHeadingProp, objNameProp, widthDisplayProp, lengthDisplayProp, xProp, yProp, rotationProp, generalPropEnd]

var linenHeadingProp = HeaderProperty.new("Linen Properties")
var linenSelector = DropdownProperty.new("Linen", "updateLinenStyle", linenStyle.keys())
var linenColourDisplay = DisplayColourProperty.new("", "", linenColour.get(linenStyle.WHITE), DisplayColourProperty.LARGE_SIZE, true, false)
var linenPropEnd = SeperatorProperty.new("Linen Properties End Line")
var linenProperties = [linenHeadingProp, linenSelector, linenColourDisplay, linenPropEnd]

var chairHeadingProp = HeaderProperty.new("Chair Properties")
var chairsNumberProp = NumericFieldProperty.new("Chairs","updateChairQuantity", chairs, 0, 8)
var chairSelectorProp = DropdownProperty.new("Chair", "updateChairStyle", chairStyle.keys())
var chairPropEnd = SeperatorProperty.new("Chair Properties End Line")
var chairProperties = [chairHeadingProp, chairsNumberProp, chairSelectorProp, chairPropEnd]
# The property Field list contains the property field corresponding to each property, using the property's name as the key and the field object as the value
var propertyFieldList = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	propertyList.append_array(generalProperties)
	propertyList.append_array(linenProperties)
	propertyList.append_array(chairProperties)
	findSelectionMenu()
	findMenu()
	findLayout()
	findMenuParent()

func findMenu():
	menu = get_tree().get_first_node_in_group(menuGroupName)
	
func findLayout():
	layout = get_tree().get_first_node_in_group(layoutGroupName)

func findSelectionMenu():
	selection_menu = get_tree().get_first_node_in_group(selectionMenuGroupName)

func findMenuParent():
	if (self.get_parent() is Container):
		menuParentNode = self.get_parent()
	else:
		var error_msg = "The menu parent node of " + str(self) + " is " + str(self.get_parent()) + ", a " + str(self.get_parent().get_class()) + ", not a Container"
		ErrorHandler.newError(error_msg)

func _on_TestDraggableObject_gui_input(event):	
	# Ensure that the menu and layout have been set
	if menu == null:
		findMenu()
	if layout == null:
		findLayout()

	var possibleSelection = false
	
	# This tracks when the object is clicked, that is, when it is first picked up
	if Input.is_action_just_pressed("LClick"):
		# this might be a selection
		possibleSelection = true
		
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
	elif possibleSelection:
		 # if it isn't a drag, it's a selection
		if selection_menu == null:
			findSelectionMenu()
		
		# the selection menu itself will later call select() on this object
		# this ensures that the selection menu is still in control of when properties are added and removed to it
		selection_menu.select(self)

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
	menuOffset = self.get_parent().get_rect().position
	
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
	#check that what is currently stored as layout is the actual active layout, and if not, update the layout
	if (layout is Venue):
		if (not layout.is_visible()):
			findLayout()
		
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

func select():
	if selected:
		return
	
	# generate propertyfields
	var newPropField
	for property in propertyList:
		newPropField = PropertyGenerator.generate(property, self)
		selection_menu.add_child(newPropField)
		propertyFieldList.get_or_add(property.propName,newPropField) # allows us to find the propertyFields corresponding to each property from their names
	
	selected = true

func deselect():
	selected = false
	
	#delete all the propertyfields
	for propertyfield in propertyFieldList.values():
		propertyfield.queue_free()
	# empty the list so we don't have keys that correspond to previous references
	propertyFieldList.clear()
	
	# it's possible that it would be better to generate all the property fields, and then just remove them as children of the parent, having them hide in memory somewhere
	# the advantage would be that we aren't regenerating and deleting things very often, but the disadvantage is that we have a bunch of memory being taken up by things that might not be seen again
