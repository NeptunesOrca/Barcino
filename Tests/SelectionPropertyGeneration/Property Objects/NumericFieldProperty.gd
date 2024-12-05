extends Property
class_name NumericFieldProperty

export(float) var defaultValue setget noChange, getDefault
export(float) var minimum setget noChange, getMin
export(float) var maximum setget noChange, getMax
export(int) var decimalPlaces setget noChange, getDecimalPlaces
export(String) var prefix setget noChange, getPrefix
export(String) var suffix setget noChange, getSuffix

const NO_MINIMUM = -INF
const NO_MAXIMUM = INF

func _init(name : String, command : String, val : float, lowerBound := NO_MINIMUM, upperBound := NO_MAXIMUM, fractDigits := 0, pre := "", post := "").(Property.PropertyTypes.NUMERIC_FIELD_PROPERTY, name, command):
	defaultValue = val
	minimum = lowerBound
	maximum = upperBound
	decimalPlaces = fractDigits
	prefix = pre
	suffix = post

func noChange(_value):
	pass

func getDefault() -> float:
	return defaultValue

func getMin() -> float:
	return minimum

func getMax() -> float:
	return maximum

func getDecimalPlaces() -> int:
	return decimalPlaces

func getPrefix() -> String:
	return prefix

func getSuffix() -> String:
	return suffix
