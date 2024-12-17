#meta-name New SelectionProperty
#meta-description Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name _CLASS_Property

#region Member Variables
@export var %somename% 
	get: return %somename%
#endregion

#region Initialization
## Class Initialization
func _init():
	pass
#end region

#region Functions

#endregion
