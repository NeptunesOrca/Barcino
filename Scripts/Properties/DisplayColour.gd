extends SelectionProperty
class_name DisplayColourProperty
## The [SelectionProperty] used to generate [DisplayColourPropertyField].
##
## Dictates the properties of a [DisplayColourPropertyField]. 

#region Constants
## The default value for the [member ColorRect.color] of the [DisplayColourPropertyField] if the [member defaultColour] is not specified.
## [br]Set to [contant Color.WHITE_SMOKE]
const DEFAULT_WHITE = Color.WHITE_SMOKE

## Specification for a small [member size]
## [br]Set to [code]12px[/code]
const SMALL_SIZE = 12

## Specification for a normal [member size]. This is the default value used in the [method _init].
## [br]Set to [code]16px[/code]
const NORMAL_SIZE = 16

## Specification for a "full" (i.e. larger than normal, yet very reasonable] [member size]
## [br]Set to [code]20px[/code]
const FULL_SIZE = 20

## Specification for a large [member size]
## [br]Set to [code]24px[/code]
const LARGE_SIZE = 24

## Specification for double the [member size] of [const NORMAL_SIZE]
## [br]Set to [code]12px[/code]
const DOUBLE_SIZE = 32

## Specification for an extremely large [member size]
## [br]Set to [code]64px[/code]
const GARGANTUAN_SIZE = 64
#endregion

#region Member Variables
## The value for the [member ColorRect.color] of the [DisplayColorPropertyField].
## [br]Set to [constant DEFAULT_WHITE] by default.
@export var defaultColour : Color :
	get:
		return defaultColour

## The side length of the square of the [ColorRect] of the [DisplayColorPropertyField]
## [br]Set to [constant NORMAL_SIZE] by default.
@export var size : int :
	get:
		return size

## Whether the [ColorRect] of the [DisplayColorPropertyField] should be centred, or left-aligned.
## [br]Set to [code]false[/code] by default.
@export var centred : bool :
	get:
		return centred

## Whether the [member SelectionProperty.name] is displayed in the [DisplayColorPropertyField] or not.
## [br]Set to [code]true[/code] by default.
@export var includeName : bool :
	get:
		return includeName
#endregion

#region Initialization
## Class Initialization.
## [br]Defaults [param name] to [code]""[/code] (empty)
## [br]Defaults [param command] to [code]""[/code] (empty)
## [br]Defaults [param colour] to [constant DEFAULT_WHITE] for [member defaultColour]
## [br]Defaults [param sideLength] to [constant NORMAL_SIZE] for [member size]
## [br]Defaults [param hztlCentred] to [code]false[/code] for [member centred]
## [br]Defaults [param showName] to [code]true[/code] for [member includeName]
func _init(name := "", command := "", colour := DEFAULT_WHITE, sideLength := NORMAL_SIZE, hztlCentred := false, showName := true):
	super(-1, name, command) #calls SelectionProperty._init()
	defaultColour = colour
	size = sideLength
	centred = hztlCentred
	includeName = showName
#endregion
