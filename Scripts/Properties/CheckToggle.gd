extends SelectionProperty
class_name CheckToggleProperty
## The [SelectionProperty] used to generate [CheckTogglePropertyField].
##
## Dictates the properties of a [CheckTogglePropertyField]. 

#region Member Variables
@export var defaultValue : bool :
	get: 
		return defaultValue
#endregion

#region Initialization
## Class Initialization
func _init(name : String, command : String, val := false):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultValue = val
#endregion

#region Functions

#endregion
