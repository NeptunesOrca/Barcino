extends Property
class_name SliderFieldProperty

export(float) var defaultValue setget noChange, getDefault
export(float) var minimum setget noChange, getMin
export(float) var maximum setget noChange, getMax
export(int) var ticks setget noChange, getTicks
export(float) var step setget noChange, getStep
export(bool) var override_maxmin setget noChange, overridesMaxMin
export(bool) var allowHigher setget noChange, getAllowsHigher
export(bool) var allowLower setget noChange, getAllowsLower

const AUTO_TICKS = -1
const NO_TICKS = 0 # this is just a convenient syntactic sugar for programmers who are adding properties
const NO_MINIMUM = -INF
const NO_MAXIMUM = INF

const DEFAULT_STEPSIZE = 1 # the default step value from Godot Slider
const DEFAULT_MINVAL = 0 # the default minimum from Godot Slider
const DEFAULT_MAXVAL = 100 # the default maximum from Godot Slider

# Override allowing above/below maximum/minimum values with these
# note that even values above 0 do not make sense, as that means there is not an override, but we are overriding to allow either higher or lower
# note that values above 7 also do not make sense, as we only check the first three bits
const NO_OVERRIDE = 0				#000: override = 0, allowLower = 0, allowHigher = 0
const OVERRIDE_NEITHER_OVERUNDER = 1#001: override = 1, allowLower = 0, allowHigher = 0
const OVERRIDE_UNDER_ONLY = 3		#011: override = 1, allowLower = 1, allowHigher = 0
const OVERRIDE_OVER_ONLY = 5		#101: override = 1, allowLower = 0, allowHigher = 0
const OVERRIDE_OVER_AND_UNDER = 7	#111: override = 1, allowLower = 0, allowHigher = 0


func _init(name : String, command : String, val : float = 0, lowerBound := NO_MINIMUM, upperBound := NO_MAXIMUM, customticks : int = AUTO_TICKS, stepsize := 1.0, override_overunder := NO_OVERRIDE).(Property.PropertyTypes.SLIDER_PROPERTY, name, command):
	defaultValue = val
	minimum = lowerBound
	maximum = upperBound
	# this seemed better than making a whole object/struct to contain two bool parameters, even though it's less intuitive
	override_maxmin = (override_overunder & 1) != 0	# uses bitmasking to check if the override_overunder has the first bit turned on (meaning override should also be on)
	if (override_maxmin):
		allowLower = (override_overunder & 2) != 0 		# uses bitmasking to check if the override_overunder has the second bit turned on (meaning allowLower should also be on)
		allowHigher = (override_overunder & 4) != 0 	# uses bitmasking to check if the override_overunder has the third bit turned on (meaning allowHigher should also be on)
	
	# ensure that step is always positive, and non-zero
	step = stepsize
	if step < 0 :
		step *= -1
	elif step == 0 :
		step = DEFAULT_STEPSIZE
	
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

func noChange(_value):
	pass

func getDefault() -> float:
	return defaultValue

func getMin() -> float:
	return minimum

func getMax() -> float:
	return maximum

func getTicks() -> int:
	return ticks

func getStep() -> float:
	return step

func getAllowsHigher() -> bool:
	return allowHigher

func getAllowsLower() -> bool:
	return allowLower

func overridesMaxMin() -> bool:
	return override_maxmin
