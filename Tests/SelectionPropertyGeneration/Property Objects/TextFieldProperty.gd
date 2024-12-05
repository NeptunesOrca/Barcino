extends Property
class_name TextFieldProperty

export(String) var defaultText setget noChange, getDefault
export(bool) var underLable setget noChange, isUnder

func _init(name : String, command := "", default := "", underneath := false).(Property.PropertyTypes.TEXT_FIELD_PROPERTY, name, command):
	defaultText = default
	underLable = underneath

func noChange(_value):
	pass

func getDefault() -> String :
	return defaultText

func isUnder() -> bool :
	return underLable
