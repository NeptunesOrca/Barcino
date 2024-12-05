extends PropertyField
class_name %CLASS%PropertyField

# Member Variables Here

# Class Initialization
func _init(obj : DraggableObject, property : %CLASS%Property).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	pass

# Other functions, as required
