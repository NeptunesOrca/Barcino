#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name HeaderProperty
## The [SelectionProperty] used to generate [HeaderPropertyField].
##
## Dictates the properties of a [HeaderPropertyField]. 

#region Member Variables
## Syntatic sugar for [member SelectionProperty.name] to make it easier to refer to with greater clarity
@export var header : String :
	get:
		return header
#endregion

#region Initialization
## Class Initialization. Requires [param name]
## [br][param name] is also used to specify [member header]
## [br][member SelectionProperty.commandName] is specified to be empty and does not have an effect.
func _init(name : String):
	super(-1, name, "") #calls SelectionProperty._init()
	header = name
#endregion
