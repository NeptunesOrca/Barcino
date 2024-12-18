#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name SeperatorProperty
## The [SelectionProperty] used to generate [SeperatorPropertyField].
##
## Dictates the properties of a [SeperatorPropertyField].
## [br]The SeperatorProperty has no properties or data, it's just a horizontal line used to mark a seperation of some kind
## [br]The [member SelectionProperty.name] is not displayed, and is only for programmers to be able to use if they want

#region Initialization
## Class Initialization.
## [br]Defaults [param name] to [code]""[/code] (empty)
## [br][member SelectionProperty.commandName] is specified to be empty and does not have an effect.
func _init(name := ""):
	super(-1, name, "")
#endregion
