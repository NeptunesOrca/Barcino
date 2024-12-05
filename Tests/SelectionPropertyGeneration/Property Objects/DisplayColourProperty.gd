extends Property
class_name DisplayColourProperty

export(Color) var defaultColour setget noChange, getDefault
export(int) var size setget noChange, getSize
export(bool) var centred setget noChange, isCentred
export(bool) var includeName setget noChange, showsName

const DEFAULT_WHITE = Color.whitesmoke
const SMALL_SIZE = 12
const NORMAL_SIZE = 16
const FULL_SIZE = 20
const LARGE_SIZE = 24
const DOUBLE_SIZE = 32
const GARGANTUAN_SIZE = 64

func _init(name := "", command := "", colour := DEFAULT_WHITE, sideLength := NORMAL_SIZE, hztlCentred := false, showName := true).(Property.PropertyTypes.DISPLAY_COLOUR_PROPERTY, name, command):
	defaultColour = colour
	size = sideLength
	centred = hztlCentred
	includeName = showName

func noChange(_value):
	pass

func getDefault() -> Color :
	return defaultColour

func getSize() -> int:
	return size

func isCentred() -> bool:
	return centred

func showsName() -> bool:
	return includeName
