#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name SliderProperty
## The [SelectionProperty] used to generate [SliderPropertyField].
##
## Dictates the properties of a [SliderPropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when the
## [br] - [HSlider] of the [SliderPropertyField] emits [signal HSlider.%signal%]

#region Constants
#region Godot Slider defaults
## The default value of [member Range.step] for the built-in [Slider]
const DEFAULT_STEPSIZE = 1
## The default value of [member Range.min_value] for the built-in [Slider]
const DEFAULT_MINVAL = 0
## The default value of [member Range.max_value] for the built-in [Slider]
const DEFAULT_MAXVAL = 100
#endregion

#region Tick Options
## If [member ticks] is this value, will calculate the [Slider.tick_count] the [HSlider] of the [SliderPropertyField] should have instead of using a programmer provided number.
const AUTO_TICKS = -1
## If [member ticks] is this value, the [HSlider] of the [SliderPropertyField] will have no ticks (i.e. [member Slider.tick_count] = 0).
## [br]A convenient syntactic sugar for programmers who are adding properties.
const NO_TICKS = 0
#endregion

#region Numeric Range Constants
## Used by [method _init] to indicate that no minimum value is desired for this [SliderProperty].
## [br]When used in [member minimum], will set [member Range.allow_lesser] to [code]true[/code] for the [HSlider] of the [NumericEntryPropertyField]
const NO_MINIMUM = -INF

## Used by [method _init] to indicate that no maximum value is desired for this [SliderProperty].
## When used in [member maximum], will set [member Range.allow_greater] to [code]true[/code] for the [HSlider] of the [NumericEntryPropertyField]
const NO_MAXIMUM = INF
#endregion

#region Override allowing above/below maximum/minimum values with these
## Used to determine which bit in [enum MaxMinOverride] corresponds to which override
enum MaxMinOverrideFlag {
	minFlag,	##Corresponds to [member allowLower]
	maxFlag		##Corresponds to [member allowHigher]
}

## Specifies overrides for maximum/minimum values using a 3-bit binary number in the form [code]yx[/code], which are then translated into decimal integers.
## [br]The least significant bit, [code]x[/code], determines if [member allowLower] should be turned on
## [br]The most significant bit, [code]y[/code], determines if [member allowHigher] should be turned on
## [br][br]Note: Values greater than 3 do not make sense, as only the first two bits of the integer are checked.
enum MaxMinOverride {
	NONE = 0,										##00: allowLower = 0, allowHigher = 0
	UNDER_ONLY = 1 << MaxMinOverrideFlag.minFlag,	##01: allowLower = 1, allowHigher = 0
	OVER_ONLY = 1 << MaxMinOverrideFlag.maxFlag,	##10: allowLower = 0, allowHigher = 1
	BOTH_OVER_AND_UNDER = UNDER_ONLY + OVER_ONLY	##11: allowLower = 1, allowHigher = 1
}
#endregion
#endregion

#region Member Variables
## The default value for the [member Range.value] for the [HSlider] in the [SliderPropertyField].
## [br]Defaults to 0.
@export var defaultValue : float :
	get:
		return defaultValue

## The value for the [member Range.min_value] for the [HSlider] in the [SliderPropertyField].
## [br]If unspecified, is set to [constant NO_MINIMUM].
@export var minimum : float :
	get:
		return minimum

## The value for the [member Range.max_value] for the [HSlider] in the [SliderPropertyField].
## [br]If unspecified, is set to [constant NO_MAXIMUM].
@export var maximum : float :
	get:
		return maximum

## The number of [i]internal[/i] visible tick marks on the [HSlider] of the of the [SliderPropertyField]. This is the value used to decide [Slider.tick_count] of the [HSlider].
## [br]The positions at either end of the slider (the [member Range.min_value] and [member Range.max_value] of the [HSlider]) are not included.
## [br]When calculated automatically (i.e. as a result of [constant AUTO_TICKS], puts each tick at a position selectable by the user.
## [br]Defaults to [constant AUTO_TICKS], which automatically calculates the number of ticks that should be visible, using [member step]
@export var ticks : int :
	get:
		return ticks

## The number between positions on the slider that the user should be able to pick from.
## [br]Defaults to [constant DEFAULT_STEPSIZE]
@export var step : float :
	get:
		return step

## Determines whether the [member Range.value] of the [HSlider] for the [SliderPropertyField] will allow values below the [member minimum].
## [br]Set using the 0th bit of [enum MaxMinOverride].
## [br]Defaults to [code]false[/code].
@export var allowLower : bool :
	get:
		return allowLower
		
## Determines whether the [member Range.value] of the [HSlider] for the [SliderPropertyField] will allow values above the [member maximum].
## [br]Set using the 1st bit of [enum MaxMinOverride].
## [br]Defaults to [code]false[/code].
@export var allowHigher : bool :
	get:
		return allowHigher
#endregion

#region Initialization
## Class Initialization. Requires [param name], [param command], and [param val].
## [br]Uses [param val] for [member defaultValue]
## [br]Defaults [param lowerBound] to [constant DEFAULT_MINVAL] for [member minimum]
## [br]Defaults [param upperBound] to [constant DEFAULT_MAXVAL] for [member maximum]
## [br]Defaults [param customticks] to [constant AUTO_TICKS] for [member ticks]
## [br]Defaults [param stepsize] to [constant DEFAULT_STEPSIZE] for [member steps]
## [br]Defaults [param override_overunder] to [enum MaxMinOverride.NONE], which is used to decide [member allowLower] and [member allowHigher]
func _init(name : String, command : String, val : float = 0, lowerBound := DEFAULT_MINVAL, upperBound := DEFAULT_MAXVAL, customticks : int = AUTO_TICKS, stepsize := DEFAULT_STEPSIZE, override_overunder : MaxMinOverride = MaxMinOverride.NONE):
	super(-1, name, command)
	defaultValue = val
	minimum = lowerBound
	maximum = upperBound
	
	#region Calculate Max/Min Overrides
	# this seemed better than making a whole object/struct to contain two bool parameters, even though it's less intuitive
	allowLower = override_overunder & (1 << MaxMinOverrideFlag.minFlag)
	allowHigher = override_overunder & (1 << MaxMinOverrideFlag.maxFlag)
	#endregion
	
	#region Ensure that step is always positive, and non-zero
	step = stepsize
	if step < 0 :
		step *= -1
	elif step == 0 :
		step = DEFAULT_STEPSIZE
	#endregion
	
	#region Calculate ticks unless provided
	# calculate ticks from step if there has not been a custom tick number given
	if customticks == AUTO_TICKS:
		if (minimum != NO_MINIMUM && maximum != NO_MAXIMUM):
			ticks = round((maximum - minimum)/step)
		else:
			ticks = NO_TICKS
	else :
		ticks = customticks
		# we adjust the step to match the ticks if the ticks are custom, but only if that isn't also custom
		if (stepsize == DEFAULT_STEPSIZE):
			var top = DEFAULT_MAXVAL
			var bottom = DEFAULT_MINVAL
			if (minimum != NO_MINIMUM):
				bottom = minimum
			if (maximum != NO_MAXIMUM):
				top = maximum
			step = (maximum - minimum)/ticks
			ticks += 1 # this is to add on the ticks at the front and the back, GODOT is just weird like that
			#TODO: check it still works this way
	#endregion
#endregion

#region Functions
func hasOverrides() -> bool:
	return allowLower || allowHigher
#endregion
