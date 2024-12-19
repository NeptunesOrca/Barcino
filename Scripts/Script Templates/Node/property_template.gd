#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name _CLASS_Property
## The [SelectionProperty] used to generate [_CLASS_PropertyField].
##
## Dictates the properties of a [_CLASS_PropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when the
## [br] - [%object%] of the [_CLASS_PropertyField] emits [signal %object%.%signal%]

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

#region String Generation Overrides
## Generates the list of member variables and their values, in the form of property: value, seperated by commas
func generatePropertiesString() -> String:
	return super() #+ ", %somename%: " + str(%somevalue%)

## Returns the name of the class. Overrides [method SelectionProperty.generateObjectClass].
func generateObjectClass() -> String:
	return "_CLASS_Property"
#endregion