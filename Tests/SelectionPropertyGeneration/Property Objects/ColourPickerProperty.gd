extends Property
class_name ColourPickerProperty

export(Color) var defaultColour setget noChange, getDefault
export(bool) var alphaEnabled setget noChange, includesAlpha

const DEFAULT_COLOUR = Color.white

func _init(name : String, command : String, default := DEFAULT_COLOUR, includeAlpha := false).(Property.PropertyTypes.COLOUR_PICKER_PROPERTY, name, command):
	defaultColour = default
	alphaEnabled = includeAlpha

func noChange(_value):
	pass

func getDefault() -> Color :
	return defaultColour

func includesAlpha() -> bool:
	return alphaEnabled
