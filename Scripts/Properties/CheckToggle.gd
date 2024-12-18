extends SelectionProperty
class_name CheckToggleProperty
## The [SelectionProperty] used to generate [CheckTogglePropertyField].
##
## Dictates the properties of a [CheckTogglePropertyField]. 

#region Member Variables
## The default value for the [member Checkbox.button_pressed] in the [CheckTogglePropertyField].
## [br]If unspecified, is set to [code]false[/code].
@export var defaultValue : bool :
	get: 
		return defaultValue
#endregion

#region Initialization
## Class Initialization. Requires [param name] and [param command].
## [br]Defaults [param val] to [code]false[/code] for [member defaultValue]
func _init(name : String, command : String, val := false):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultValue = val
#endregion
