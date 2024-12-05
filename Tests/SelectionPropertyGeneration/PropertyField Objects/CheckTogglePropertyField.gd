extends PropertyField
class_name CheckTogglePropertyField

# Member Variables Here
var checkbox : CheckBox

# Class Initialization
func _init(obj : DraggableObject, property : CheckToggleProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# create and setup the checkbox
	checkbox = CheckBox.new()
	checkbox.pressed = property.defaultValue
	self.add_child(checkbox)
	
	#connect command
	checkbox.connect("toggled", obj, property.onUpdate)
	#the toggled signal sends the bool value of the checkbox

# Other functions, as required
