extends Property
class_name HeaderProperty

# Declare member variables here. Examples:
# var a = 2
# var b = "header"
export(String) var header setget noChange, getHeader
export(bool) var includeName setget noChange, isUnder

func _init(name : String).(Property.PropertyTypes.HEADER_PROPERTY, name, ""):
	header = name

func noChange(_value):
	pass

func getHeader() -> String :
	return header

func isUnder() -> bool :
	return includeName
