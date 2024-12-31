#meta-name: New DraggableObject
#meta-description: Template for creating a new DraggableObjects
#meta-default: true
extends _BASE_
class_name _CLASS_

#region Constants and Enumerations

#endregion

#region Member Variables

#region Object Properties For Selection

#endregion
#endregion

#region Class Initialization
## Class Initialization. Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "_CLASS_".
func _init(typeName : String = "_CLASS_"):
#generate any properties here first, so that they will be properly added by collectProperties() when super() is called
	super(typeName)

## Collects all the [SelectionProperty]s to be put in the [member propertyList] during [method _init].
## [br] Overrides [method DraggableObject.collectProperties].
func collectProperties():
	super()
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
#func _ready():
#	super()

## Sets the point the [DraggableObject] should rotate around. Defaults to the centre, but can be overridden by subclasses
## [br] Used during [method _ready].
#func setRotationPoint():
#	set_pivot_offset(size/2)

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