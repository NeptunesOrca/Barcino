#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name DisplayTextProperty
## The [SelectionProperty] used to generate [DisplayTextPropertyField].
##
## Dictates the properties of a [DisplayTextPropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] has no effect.

#region Member Variables
## The value for the [member Label.text] in the [DisplayTextPropertyField].
## [br]If unspecified, is set to [code]""[/code] (empty).
@export var text : String :
	get:
		return text

## Whether the [member SelectionProperty.name] is displayed in the [DisplayTextPropertyField] or not.
## [br]Set to [code]true[/code] by default.
@export var includeName : bool :
	get:
		return includeName
#endregion

#region Initialization
## Class Initialization.
## [br]Defaults [param name] to [code]""[/code] (empty)
## [br]Defaults [param displayText] to [code]""[/code] (empty) for [member text]
## [br]Defaults [param showName to [code]true[/code] for [member includeName]
## [br][member SelectionProperty.commandName] is specified to be empty and does not have an effect.
func _init(name := "", displayText := "", showName := true):
	super(-1, name, "") #calls SelectionProperty._init()
	text = displayText
	includeName = showName
#endregion

#region Functions

#endregion
