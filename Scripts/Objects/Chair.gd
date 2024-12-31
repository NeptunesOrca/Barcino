#meta-name: New DraggableObject
#meta-description: Template for creating a new DraggableObjects
#meta-default: true
extends DraggableObject
class_name Chair

#region Constants and Enumerations
enum chairStyle {
	WHITE_FOLDING,
	BROWN_FOLDING,
	GREEN_FOLDING,
	DIWAN,
	OZAWA,
	IKOINOBA,
}

var chairNames = {
	chairStyle.WHITE_FOLDING : "White Folding Chair",
	chairStyle.BROWN_FOLDING : "Brown Folding Chair",
	chairStyle.GREEN_FOLDING : "Green Folding Chair",
	chairStyle.DIWAN : "Diwan Chair",
	chairStyle.OZAWA : "Ozawa Chair",
	chairStyle.IKOINOBA : "Ikoi-no-ba Chair",
}

var chairLengths = {
	chairStyle.WHITE_FOLDING : 1.5,
	chairStyle.BROWN_FOLDING : 1.5,
	chairStyle.GREEN_FOLDING : 1.5,
	chairStyle.DIWAN : 2,
	chairStyle.OZAWA : 2,
	chairStyle.IKOINOBA : 1.75,
}

var chairWidths = {
	chairStyle.WHITE_FOLDING : 1.5,
	chairStyle.BROWN_FOLDING : 1.5,
	chairStyle.GREEN_FOLDING : 1.5,
	chairStyle.DIWAN : 2,
	chairStyle.OZAWA : 1.75, #TODO: Missing measurement
	chairStyle.IKOINOBA : 1.75,
}

##May need to define images for the various chairs here as well
#endregion

#region Member Variables

#region Object Properties For Selection
#region Size Information
##
var length : float
##
var width : float
#endregion

#region Style Information
##
@export var chairType : chairStyle
#endregion
#endregion
#endregion

#region Class Initialization
## Class Initialization. Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "Chair".
func _init(style : chairStyle = chairStyle.WHITE_FOLDING):
	changeType(style)
	super(typeName)

## Collects all the [SelectionProperty]s to be put in the [member propertyList] during [method _init].
## [br] Overrides [method DraggableObject.collectProperties].
func collectProperties():
	super()

## Sets the point the [DraggableObject] should rotate around. Defaults to the centre. See [method DraggableObject.setRorationPoint]
## [br] Used during [method _init].
## [br][br] See [method Control.set_anchors_preset], and [enum Control.LayoutPreset.PRESET_CENTER]
#func setRotationPoint():
#	set_anchors_preset(Control.PRESET_CENTER)
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
#func _ready():
#	super()

#region Finder Functions
## Function that collects all the finders together for when we want to do all of them at once.
## When called in [method _ready], to be deferred until after first frame, to ensure that all of the Key Nodes have a chance to add themselves to the appropriate groups before this occurs
#func findAllKeyNodes():
#	super()
#endregion
#endregion

#region Checks

#endregion

#region Properties Adjustment
func changeType(newStyle : chairStyle) :
	chairType = newStyle
	typeName = chairNames[newStyle]
	length = chairLengths[newStyle]
	width = chairWidths[newStyle]
#endregion

#region Functions

#endregion
