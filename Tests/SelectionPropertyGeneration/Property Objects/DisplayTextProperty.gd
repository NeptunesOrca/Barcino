extends Property
class_name DisplayTextProperty

export(String) var text setget noChange, getText
export(bool) var includeName setget noChange, showsName

func _init(name : String, displayText := "", showName := true).(Property.PropertyTypes.DISPLAY_TEXT_PROPERTY, name, ""):
	text = displayText
	includeName = showName

func noChange(_value):
	pass

func getText() -> String :
	return text

func showsName() -> bool :
	return includeName
