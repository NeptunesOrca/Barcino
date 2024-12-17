#meta-name: New PropertyField
#meta-description: Template for creating a new PropertyFields. Will automatically append "PropertyField" to the end of whatever name is given
#meta-default: true
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