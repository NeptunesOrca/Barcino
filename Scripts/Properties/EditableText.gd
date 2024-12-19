#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name EditableTextProperty
## The [SelectionProperty] used to generate [EditableTextPropertyField].
##
## Dictates the properties of a [EditableTextPropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when the
## [br] - [EditableTextPropertyField] emits [signal EditableTextPropertyField.sendText] when the [TextEdit] of the [EditableTextPropertyField] emits [signal TextEdit.text_changed]

#region Member Variables
## The value for the [member TextEdit.text] in the [EditableTextPropertyField].
## [br]If unspecified, is set to [code]""[/code] (empty).
@export var defaultText : String :
	get:
		return defaultText

## Whether the [member SelectionProperty.name] is displayed on a seperate line from the [member TextEdit.text] in the [EditableTextPropertyField] or not.
## [br]Set to [code]false[/code] by default.
@export var underLable : bool :
	get:
		return underLable
#endregion

#region Initialization
## Class Initialization. Requires [param name] and [param command].
## [br]Defaults [param default] to [code]""[/code] (empty) for [member defaultText]
## [br]Defaults [param underneath] to [code]true[/code] for [member underLable]
func _init(name : String, command : String, default := "", underneath := false):
	super(-1, name, command)
	defaultText = default
	underLable = underneath
#endregion
