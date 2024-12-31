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

var chairImages = {
	chairStyle.WHITE_FOLDING : "res://Objects/ObjectImages/WhiteFoldingChair.png",
	chairStyle.BROWN_FOLDING : "res://Objects/ObjectImages/BrownFoldingChair.png",
	chairStyle.GREEN_FOLDING : "res://Objects/ObjectImages/GreenFoldingChair.png",
	chairStyle.DIWAN : "res://Objects/ObjectImages/DiwanChair.png",
	chairStyle.OZAWA : "res://Objects/ObjectImages/OzawaChair.png",
	chairStyle.IKOINOBA : "res://Objects/ObjectImages/IkoiNoBaChair.png",
}
#endregion

#region Member Variables

#region Object Properties For Selection
#region Size Information
#var sizeInfoHeaderProp = HeaderProperty.new("Size")

##
var length : float
##
var width : float

var l_dimensionalProp : DisplayTextProperty
var w_dimensionalProp : DisplayTextProperty

var sizeSep = SeperatorProperty.new("Size Seperators")
## The collection of properties relating to size
var sizeProps
#endregion

#region Style Information
var chairTypeHeaderProp = HeaderProperty.new("Chair Type")

##
@export var chairType : chairStyle
var chairOptions : Array = chairStyle.keys()
var chairTypeProp = DropdownProperty.new("Type","changeType",chairOptions)

var chairTypeSep = SeperatorProperty.new()
##
var chairTypeProps = [chairTypeHeaderProp,chairTypeProp,chairTypeSep]
#endregion
#endregion
#endregion

#region Class Initialization
## Class Initialization. Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "Chair".
func _init(style : chairStyle = chairStyle.WHITE_FOLDING):
	changeType(style)
	
	# Generate the dimensional selection properties
	var unit = "'"
	l_dimensionalProp = DisplayTextProperty.new("Length",str(length) + unit)
	w_dimensionalProp = DisplayTextProperty.new("Width", str(width) + unit)
	#generate any properties first, so that they will be properly added by collectProperties() when super() is called
	
	super(self.typeName)

## Collects all the [SelectionProperty]s to be put in the [member propertyList] during [method _init].
## [br] Overrides [method DraggableObject.collectProperties].
func collectProperties():
	super()
	
	sizeProps = [l_dimensionalProp, w_dimensionalProp, sizeSep]
	propertyList.append_array(sizeProps)
	
	propertyList.append_array(chairTypeProps)

## Sets the point the [DraggableObject] should rotate around. Defaults to the centre. See [method DraggableObject.setRorationPoint]
## [br] Used during [method _init].
## [br][br] See [method Control.set_anchors_preset], and [enum Control.LayoutPreset.PRESET_CENTER]
#func setRotationPoint():
#	set_anchors_preset(Control.PRESET_CENTER)
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
#func _ready():
	#super()

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
## Changes the [member chairType] to the selected [param newStyle]. Updates the rest of the chair to match the selected [chairStyle].
func changeType(newStyle : chairStyle) :
	chairType = newStyle
	updateTypeName(chairNames[newStyle])
	length = chairLengths[newStyle]
	width = chairWidths[newStyle]
	
	#Update the image
	set_texture(load(chairImages[newStyle]))

## Updates the superclass [member DraggableObject.typeName] and [member DraggableObject.typeNameProp]'s text.
## [br] Done in the [Chair] class instead of [DraggableObject] because only [Chair] is likely to change [member DraggableObject.typeName].
## [br] Can put in [DraggableObject] if something else needs to do it too.
func updateTypeName(newType : String):
	self.typeName = newType
	if typeNameProp != null :
		typeNameProp.text = newType
#endregion

#region Functions

#endregion
