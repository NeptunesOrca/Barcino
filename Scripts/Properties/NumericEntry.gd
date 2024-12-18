#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name NumericEntryProperty
## The [SelectionProperty] used to generate [NumericEntryPropertyField].
##
## Dictates the properties of a [NumericEntryPropertyField].

#region Constants
#region Numeric Range Constants
## Used by [method _init] to indicate that no minimum value is desired for this [NumericEntryProperty].
## [br]When used in [member minimum], will set [member Range.allow_lesser] to [code]true[/code] for the [SpinBox] of the [NumericEntryPropertyField]
const NO_MINIMUM = -INF

## Used by [method _init] to indicate that no maximum value is desired for this [NumericEntryProperty].
## When used in [member maximum], will set [member Range.allow_greater] to [code]true[/code] for the [SpinBox] of the [NumericEntryPropertyField]
const NO_MAXIMUM = INF
#endregion
#endregion

#region Member Variables
## The default value for the [member Range.value] for the [SpinBox] in the [NumericEntryPropertyField].
@export var defaultValue : float :
	get:
		return defaultValue

## The value for the [member Range.min_value] for the [SpinBox] in the [NumericEntryPropertyField].
## [br]If unspecified, is set to [constant NO_MINIMUM].
@export var minimum : float :
	get:
		return minimum

## The value for the [member Range.max_value] for the [SpinBox] in the [NumericEntryPropertyField].
## [br]If unspecified, is set to [constant NO_MAXIMUM].
@export var maximum : float :
	get:
		return maximum

## The number of decimal places that should be displayed by the [member Range.min_value] for the [SpinBox] in the [NumericEntryPropertyField].
## [br]If unspecified, is set to [code]0[/code].
@export var decimalPlaces : int :
	get:
		return decimalPlaces

## The [member SpinBox.prefix] displayed in front of the [member Range.value] of the [NumericEntryPropertyField].
## [br]If unspecified, is set to [code]""[/code] (empty).
@export var prefix : String :
	get:
		return prefix

## The [member SpinBox.suffix] displayed after of the [member Range.value] of the [NumericEntryPropertyField].
## [br]If unspecified, is set to [code]""[/code] (empty).
@export var suffix : String :
	get:
		return suffix
#endregion

#region Initialization
## Class Initialization. Requires [param name], [param command], and [param val].
## [br]Uses [param val] for [member defaultValue]
## [br]Defaults [param lowerBound] to [constant NO_MINIMUM] for [member minimum]
## [br]Defaults [param upperBound] to [constant NO_MAXIMUM] for [member maximum]
## [br]Defaults [param fractDigits] to [code]0[/code] for [member decimalPlaces]
## [br]Defaults [param pre] to [code]""[/code] (empty) for [member prefix]
## [br]Defaults [param post] to [code]""[/code] (empty) for [member suffix]
func _init(name : String, command : String, val : float, lowerBound := NO_MINIMUM, upperBound := NO_MAXIMUM, fractDigits := 0, pre := "", post := ""):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultValue = val
	minimum = lowerBound
	maximum = upperBound
	decimalPlaces = fractDigits
	prefix = pre
	suffix = post
#endregion
