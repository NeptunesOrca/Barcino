extends PropertyField
class_name NumericFieldPropertyField

# Member Variables Here
var numbox : SpinBox

# Class Initialization
func _init(obj : DraggableObject, property : NumericFieldProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# create and setup the number box
	numbox = SpinBox.new()
	if (property.minimum > NumericFieldProperty.NO_MINIMUM):
		numbox.min_value = property.minimum
		numbox.allow_lesser = false
	else:
		numbox.allow_lesser = true
	if (property.maximum < NumericFieldProperty.NO_MAXIMUM):
		numbox.max_value = property.maximum
		numbox.allow_greater = false
	else:
		numbox.allow_greater = true
	numbox.prefix = property.prefix
	numbox.suffix = property.suffix
	numbox.step = pow(0.1, property.decimalPlaces)
	numbox.value = property.defaultValue
	numbox.size_flags_horizontal = SIZE_EXPAND_FILL # will take up whatever space it can after the name
	
	# add the numbox
	self.add_child(numbox)
	
	#connect the numbox
	numbox.connect("value_changed",obj,property.onUpdate)
	#this will directly send the float value, so there is no need for the object to use a getter on this

# Other functions, as required
