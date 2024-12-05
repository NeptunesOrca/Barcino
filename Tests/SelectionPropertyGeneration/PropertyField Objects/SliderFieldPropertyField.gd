extends PropertyField
class_name SliderFieldPropertyField

# Member Variables Here
var slider : HSlider
var parentContainer : VBoxContainer

# Class Initialization
func _init(obj : DraggableObject, property : SliderFieldProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# create and setup the slider
	slider = HSlider.new()
	slider.scrollable = true
	slider.tick_count = property.ticks
	# this sets a default behaviour for maximum and minimums, including whether the user can go above/below them (only if they are specified)
	if (property.minimum > SliderFieldProperty.NO_MINIMUM):
		slider.min_value = property.minimum
		slider.allow_lesser = false
	else:
		slider.allow_lesser = true
		#displayed min will be whatever the default it
	if (property.maximum < SliderFieldProperty.NO_MAXIMUM):
		slider.max_value = property.maximum
		slider.allow_greater = false
	else:
		slider.allow_greater = true
		#displayed max will be whatever the default is
		
	#override allow higher/lower if specified
	if (property.override_maxmin):
		slider.allow_greater = property.allowHigher
		slider.allow_lesser = property.allowLower
	slider.step = property.step
	slider.value = property.defaultValue
	slider.size_flags_horizontal = SIZE_EXPAND_FILL # will take up whatever space it can after the name
	
	# create a dummy vBox so that we can stack elements vertically instead of horizontally
	parentContainer = VBoxContainer.new()
	parentContainer.size_flags_horizontal = SIZE_EXPAND_FILL
	self.add_child(parentContainer)
	#restack the name within the parentContainer
	self.remove_child(self.propertyName)
	parentContainer.add_child(self.propertyName)
	# add the textbox to the container
	parentContainer.add_child(slider)
	
	# connect the slider
	slider.connect("value_changed",obj,property.onUpdate)
	#value_changed sends a float of value, so no need for setters or getters or anything

# Other functions, as required
