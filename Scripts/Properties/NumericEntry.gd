#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name NumericEntryProperty
## The [SelectionProperty] used to generate [NumericEntryPropertyField].
##
## Dictates the properties of a [NumericEntryPropertyField].

#region Constants
const NO_MINIMUM = -INF
const NO_MAXIMUM = INF
#endregion

#region Member Variables
@export var defaultValue : float :
	get:
		return defaultValue

@export var minimum : float :
	get:
		return minimum

@export var maximum : float :
	get:
		return maximum

@export var decimalPlaces : int :
	get:
		return decimalPlaces

@export var prefix : String :
	get:
		return prefix

@export var suffix : String :
	get:
		return suffix
#endregion

#region Initialization
## Class Initialization
func _init(name : String, command : String, val : float, lowerBound := NO_MINIMUM, upperBound := NO_MAXIMUM, fractDigits := 0, pre := "", post := ""):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultValue = val
	minimum = lowerBound
	maximum = upperBound
	decimalPlaces = fractDigits
	prefix = pre
	suffix = post
#endregion

#region Functions

#endregion
