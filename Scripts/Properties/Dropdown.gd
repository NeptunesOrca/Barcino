#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name DropdownProperty

#region Constants

#endregion

#region Member Variables
@export var options : PackedStringArray :
	get:
		return options
#endregion

#region Initialization
## Class Initialization
func _init(name : String, command : String, optionList : Array):
	super(-1, name, command) #calls SelectionProperty._init()
	options = PackedStringArray(optionList) # turns whatever the type of optionsList into strings so that they can be used properly
#endregion

#region Functions

#endregion
