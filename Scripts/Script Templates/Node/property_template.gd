#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name _CLASS_Property

#region Constants

#endregion

#region Member Variables
@export var %somename% : %sometype% :
	get:
		return %somename%
#endregion

#region Initialization
## Class Initialization
func _init(name : String, command : String):
	super._init(-1, name, command)
#endregion

#region Functions

#endregion
