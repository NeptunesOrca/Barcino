extends PropertyField
class_name ColourPickerPropertyField

# Member Variables Here
var colourpicker : ColorPickerButton

# Class Initialization
func _init(obj : DraggableObject, property : ColourPickerProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# Create the colourpicker
	colourpicker = ColorPickerButton.new()
	colourpicker.color = property.defaultColour
	colourpicker.edit_alpha = property.alphaEnabled
	colourpicker.size_flags_horizontal = SIZE_EXPAND_FILL # fill up all the space after the name
	self.add_child(colourpicker)
	
	#Connect
	colourpicker.connect("color_changed",obj,property.onUpdate)
	# the color_changed signal will send the new Color to obj to handle

# Other functions, as required
