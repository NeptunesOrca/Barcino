extends Property
class_name CheckToggleProperty

export(bool) var defaultValue setget noChange, getDefault

func _init(name : String, command : String, val := false).(Property.PropertyTypes.CHECK_TOGGLE_PROPERTY, name, command):
	defaultValue = val

func noChange(_value):
	pass

func getDefault() -> bool :
	return defaultValue
