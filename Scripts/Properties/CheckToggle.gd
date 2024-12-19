extends SelectionProperty
class_name CheckToggleProperty
## The [SelectionProperty] used to generate [CheckTogglePropertyField].
##
## Dictates the properties of a [CheckTogglePropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when:
## [br] - the [CheckBox] of the [CheckTogglePropertyField] emits [signal CheckBox.toggled].

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

#region String Generation Overrides
## Generates the list of member variables and their values, in the form of property: value, seperated by commas
func generatePropertiesString() -> String:
	return super() + ", defaultValue: " + str(defaultValue)

## Returns the name of the class. Overrides [method SelectionProperty.generateObjectClass].
func generateObjectClass() -> String:
	return "CheckToggleProperty"
#endregion
