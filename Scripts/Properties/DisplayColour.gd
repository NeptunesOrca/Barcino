#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name DisplayColourProperty
## The [SelectionProperty] used to generate [DisplayColourPropertyField].
##
## Dictates the properties of a [DisplayColourPropertyField]. 

#region Constants
const DEFAULT_WHITE = Color.WHITE_SMOKE
const SMALL_SIZE = 12
const NORMAL_SIZE = 16
const FULL_SIZE = 20
const LARGE_SIZE = 24
const DOUBLE_SIZE = 32
const GARGANTUAN_SIZE = 64
#endregion

#region Member Variables
@export var defaultColour : Color :
	get:
		return defaultColour

@export var size : int :
	get:
		return size

@export var centred : bool :
	get:
		return centred

@export var includeName : bool :
	get:
		return includeName
#endregion

#region Initialization
## Class Initialization
func _init(name := "", command := "", colour := DEFAULT_WHITE, sideLength := NORMAL_SIZE, hztlCentred := false, showName := true):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultColour = colour
	size = sideLength
	centred = hztlCentred
	includeName = showName
#endregion

#region Functions

#endregion
