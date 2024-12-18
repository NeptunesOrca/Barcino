#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name DisplayTextProperty
## The [SelectionProperty] used to generate [DisplayTextPropertyField].
##
## Dictates the properties of a [DisplayTextPropertyField]. 

#region Constants

#endregion

#region Member Variables
@export var text : String :
	get:
		return text

@export var includeName : bool :
	get:
		return includeName
#endregion

#region Initialization
## Class Initialization
func _init(name := "", displayText := "", showName := true):
	super(-1, name, "") #calls SelectionProperty._init()
	text = displayText
	includeName = showName
#endregion

#region Functions

#endregion
