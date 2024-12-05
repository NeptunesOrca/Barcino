extends Property
class_name ParagraphFieldProperty

export(String) var defaultText setget noChange, getDefault
export(int) var lines setget noChange, getLines

func _init(name : String, command := "", default := "", minlines := 1).(Property.PropertyTypes.PARAGRAPH_FIELD_PROPERTY, name, command):
	defaultText = default
	lines = minlines

func noChange(_value):
	pass

func getDefault() -> String :
	return defaultText

func getLines() -> int :
	return lines
