extends SelectionPropertyField
class_name DisplayColourPropertyField
## The [SelectionPropertyField] generated by [DisplayColourProperty].
##
## Allows the user to interact with the properties of [DraggableObject]s through the [SelectionMenu].
## [br]Executes the definition given by a [DisplayColourProperty].
## [br][br]Designed to display a colour square of a specified size.
## [br][br]Deletes the [member SelectionPropertyField.propertyName].
## [br][br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when:
## [br] - [DisplayColourPropertyField] emits [signal DisplayColourPropertyField.colourChanged]

#region Custom Signal
## Custom signal emitted when [colorbox] has its [member ColorRect.color] changed via [method updateColour]
signal colourChanged(newColour)
#endregion

#region Member Variables
## The [ColorRect] that will display a square of colour as defined by the [ColourPickerProperty]
var colourbox : ColorRect
## The [Container] that the [member colourbox] will go in.
## [br]If [member DisplayColourProperty.centred] is true, will be a [CenterContainer]. Otherwise, will be a [HBoxContainer].
var parentContainer : Container
#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : DisplayColourProperty):
	super(obj, property) #calls SelectionPropertyField._init()
	
	#Create or find the parentContainer for the colourbox to go in
	if (property.centred): # If centred, create a new CenterContainer for the colourbox
		parentContainer = CenterContainer.new()
		self.add_child(parentContainer)
	else: #otherwise create a new HBox
		parentContainer = HBoxContainer.new()
	parentContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parentContainer.size_flags_vertical = Control.SIZE_SHRINK_CENTER # Needed to make the parent container not grow boxes it isn't supposed to
	self.add_child(parentContainer)
	
	# Create the colourbox to display the colour
	colourbox = ColorRect.new()
	colourbox.color = property.defaultColour
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	self.size_flags_vertical = Control.SIZE_FILL
	colourbox.custom_minimum_size = Vector2(property.size, property.size) # makes the box a square
	parentContainer.add_child(colourbox)
	
	# Remove the name if it's flagged as not included
	if (not property.includeName):
		self.propertyName.queue_free()
	
	# Connection
	self.colourChanged.connect(Callable(obj, property.commandName))
#endregion

#region Colour Functions
## Used to change the colour of the [member colourbox]. Sends [signal colourChanged]
func updateColour(newColour : Color):
	colourbox.color = newColour
	emit_signal("colourChanged", newColour)

## Used to get the current colour of the [member colourbox].
func getColour() -> Color:
	return colourbox.color
#endregion
