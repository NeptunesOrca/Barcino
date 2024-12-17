#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name CheckToggleProperty

#region Member Variables
@export var defaultValue : bool :
	get: 
		return defaultValue
#endregion

#region Initialization
## Class Initialization
func _init():
	pass
#end region

#region Functions

#endregion
