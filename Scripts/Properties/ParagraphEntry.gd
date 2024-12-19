#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name ParagraphEntryProperty
## The [SelectionProperty] used to generate [ParagraphEntryPropertyField].
##
## Dictates the properties of a [ParagraphEntryPropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when the
## [br] - [EditableTextPropertyField] emits [signal EditableTextPropertyField.sendText] when the [TextEdit] of the [EditableTextPropertyField] emits [signal TextEdit.text_changed]

#region Member Variables
## The value for the [member TextEdit.text] in the [ParagraphEntryPropertyField].
## [br]If unspecified, is set to [code]""[/code] (empty).
@export var defaultText : String :
	get:
		return defaultText

## The number of lines tall that [member TextEdit] should be in the [ParagraphEntryPropertyField].
## [br]If unspecified, is set to [code]0[/code]
@export var lines : int :
	get:
		return lines
#endregion

#region Initialization
## Class Initialization. Requires [param name] and [param command].
## [br]Defaults [param default] to [code]""[/code] (empty) for [member defaultText]
## [br]Defaults [param num_lines] to [code]1[/code] for [member lines]
func _init(name : String, command : String, default := "", num_lines :=1):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultText = default
	lines = num_lines
#endregion
