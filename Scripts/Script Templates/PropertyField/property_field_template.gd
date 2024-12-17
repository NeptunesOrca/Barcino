#meta-name: New PropertyField
#meta-description: 
extends PropertyField
class_name _CLASS_PropertyField

#region Member Variables

#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : _CLASS_Property).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	pass
#end region

#region Functions

#endregion