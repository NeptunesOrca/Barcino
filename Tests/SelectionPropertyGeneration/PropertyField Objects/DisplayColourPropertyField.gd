extends PropertyField
class_name DisplayColourPropertyField

# Member Variables Here
var colourbox : ColorRect
var parentContainer : Container
signal colourChanged(newColour)

# Class Initialization
func _init(obj : DraggableObject, property : DisplayColourProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	#Create or find the parentContainer for the colourbox to go in
	if (property.centred):
		parentContainer = CenterContainer.new()
		parentContainer.size_flags_horizontal = SIZE_EXPAND_FILL
		self.add_child(parentContainer)
	else:
		parentContainer = self
	
	# Create the display colour
	colourbox = ColorRect.new()
	colourbox.color = property.defaultColour
	
#	colourbox.size_flags_vertical = SIZE_EXPAND_FILL
#	print(colourbox.rect_size)
#	var sideLength = colourbox.rect_size.y # gets the height of the box and uses it to define the size of the box
	colourbox.rect_min_size = Vector2(property.size, property.size) # makes the box a square
	
	# Remove the name if it's flagged as not included
	if (not property.includeName):
		self.propertyName.queue_free()
	
	# Connection
	self.connect("colourChanged", obj, property.onUpdate)
	
	parentContainer.add_child(colourbox)

# Other functions, as required
#func getColourbox():
#	return colourbox

func updateColour(newColour : Color):
	colourbox.color = newColour
	emit_signal("colourChanged", newColour)

func getColour() -> Color:
	return colourbox.color
