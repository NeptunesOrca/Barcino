#meta-name: New DraggableObject
#meta-description: Template for creating a new DraggableObjects
#meta-default: true
extends DraggableObject
class_name Chair

#region Constants and Enumerations

#endregion

#region Member Variables

#region Object Properties For Selection

#endregion
#endregion

#region Class Initialization
## Class Initialization. Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "Chair".
func _init(typeName : String = "Chair"):
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

#endregion

#region Functions

#endregion
