#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name EditableTextProperty

#region Constants

#endregion

#region Member Variables
@export var defaultText : String :
	get:
		return defaultText

@export var underLable : bool :
	get:
		return underLable
#endregion

#region Initialization
## Class Initialization
func _init(name : String, command : String, default := "", underneath := false):
	super(-1, name, command)
	defaultText = default
	underLable = underneath
#endregion

#region Functions

#endregion
