#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name DropdownProperty
## The [SelectionProperty] used to generate [DropdownPropertyField].
##
## Dictates the properties of a [DropdownPropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when the
## [br] - [OptionButton] of the [DropdownPropertyField] emits [signal OptionButton.item_selected]

#region Member Variables
## The list of options available within the [OptionButton] of the [DropdownPropertyField]
## [br]All options are stored as [String]s, though they are converted from any type in [method _init]
@export var options : PackedStringArray :
	get:
		return options
#endregion

#region Initialization
## Class Initialization. Requires [param name], [param command], and [param optionList].
## [br][param optionList] can be an [Array] of any type, with those types being converted to [String]s during the function call.
func _init(name : String, command : String, optionList : Array):
	super(-1, name, command) #calls SelectionProperty._init()
	options = PackedStringArray(optionList) # turns whatever the type of optionsList into strings so that they can be used properly
#endregion

#region String Generation Overrides
## Generates the list of member variables and their values, in the form of property: value, seperated by commas
func generatePropertiesString() -> String:
	return super() #+ ", options: " + str(options)

## Returns the name of the class. Overrides [method SelectionProperty.generateObjectClass].
func generateObjectClass() -> String:
	return "DropdownProperty"
#endregion

#region Generate Property Field
## Returns the [DropdownPropertyField] generated from the definition provided by the [DropdownProperty].
func generate(obj : DraggableObject) -> SelectionPropertyField :
	return DropdownPropertyField.new(obj, self)
#endregion
