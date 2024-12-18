#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name _CLASS_Property
## The [SelectionProperty] used to generate [_CLASS_PropertyField].
##
## Dictates the properties of a [_CLASS_PropertyField].

#region Constants

#endregion

#region Member Variables
## Somedescription
## [br]If unspecified, is set to [code]%value%[/code]
@export var %somename% : %sometype% :
	get:
		return %somename%
#endregion

#region Initialization
## Class Initialization. Requires [param name] and [param command]
## [br]Defaults [param something] to [code]%value%[/code] for [member somename]
func _init(name : String, command : String):
	super(-1, name, command) #calls SelectionProperty._init()
#endregion