#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name ParagraphFieldProperty

#region Constants

#endregion

#region Member Variables
@export var defaultText : String :
	get:
		return defaultText

@export var lines : int :
	get:
		return lines
#endregion

#region Initialization
## Class Initialization
func _init(name : String, command := "", default := "", num_lines :=1):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultText = default
	lines = num_lines
#endregion

#region Functions

#endregion
