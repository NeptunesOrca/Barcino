#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name DropdownProperty
## The [SelectionProperty] used to generate [DropdownPropertyField].
##
## Dictates the properties of a [DropdownPropertyField]. 

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

#region Functions

#endregion
