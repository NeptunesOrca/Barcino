#meta-name: New DraggableObject
#meta-description: Template for creating a new DraggableObjects
#meta-default: true
extends DraggableObject
class_name Table

#region Constants and Enumerations
enum tableShapeType {
	ROUND,
	RECTANGULAR,
	SEMICIRCULAR
}

enum linenStyle {
	NONE,
	WHITE,
	CREAM,
	BLACK,
	GREEN,
}

const linenColour = {
	linenStyle.NONE : Color.TRANSPARENT,
	linenStyle.WHITE : Color.WHITE,
	linenStyle.CREAM : Color.WHEAT,
	linenStyle.BLACK : Color.BLACK,
	linenStyle.GREEN : Color.DARK_GREEN,
}
#endregion

#region Member Variables

#region Object Properties For Selection

#region Size Information
var diameter : float
var width : float
var length : float
var shape : tableShapeType

var d_or_l_dimensionalProp : DisplayTextProperty
var w_dimensionalProp : DisplayTextProperty
#endregion

#region Chairs
var totalChairs : int = 0 #TODO: switch this to being chairs.length
var chairs #TODO: switch this to being an actual number of chair children of the table
var chairType #TODO specify with enum from Chair class
#var evenChairSpacing : bool
var maxchairs : int

var chairsNumProp = NumericEntryProperty.new("Chairs", "changeChairNumber", totalChairs, 0, maxchairs)
var chairOptions : Array = [] #TODO specify with enum from Chair class
var chairTypeProp = DropdownProperty.new("Chair Type", "changeChairType", chairOptions)
#endregion

#region Linens
var hasLinen : bool = false
var linenType : linenStyle
var linenOptions : Array = linenStyle.keys()
var linenTypeProp = DropdownProperty.new("Linen Type", "changeLinen", linenOptions)
#endregion
#endregion
#endregion

#region Class Initialization
## Class Initialization. Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "Table", but can be overridden by subclasses.
## [br] Also takes in the [param maximumChairs] that can fit around the table. Defaults to 8, but can be overridden by subclasses.
func _init(typeName : String = "Table", maximumChairs : int = 8):
	super(typeName)
	maxchairs = maximumChairs
	
## Collects all the [SelectionProperty]s to be put in the [member propertyList] during [method _init].
## [br] Overrides [method DraggableObject.collectProperties].
func collectProperties():
	super()
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
#func _ready():
#	super()
#endregion

#region Checks

#endregion

#region Properties Adjustment
func changeLinen(typeIndex):
	linenType = typeIndex
	
	#Sort the linen options list to have the selected linen type at the front
	#This way, the user will see the selected linen type as the selected type if they 
	#chairOptions.push_front(chairOptions.pop_at(typeIndex))
	DropdownPropertyField.putAtFrontOfArray(linenOptions,typeIndex)

func changeChairNumber(newnum):
	totalChairs = newnum
	
	# Add or remove chairs as required
	var numToAdjust
	var functionToUse
	if totalChairs == chairs.length():
		# If they're the same, just respace and end right away
		respaceChairs()
		return
	elif totalChairs < chairs.length():
		# Too many chairs, remove them
		numToAdjust = totalChairs - chairs.length()
		functionToUse = Callable(deleteChair)
	else:
		# Not enought chairs, add them
		numToAdjust = chairs.length() - totalChairs
		functionToUse = Callable(addChair)
	
	# Do the adding or removing
	for i in range(numToAdjust):
		call(functionToUse)
		
	respaceChairs()

func changeChairType(typeIndex):
	chairType = typeIndex #TODO make this the correct thing after implementing Chair
	
	#Sort the chair options list to have the selected chair type at the front
	#This way, the user will see the selected chair type as the selected type if they 
	#chairOptions.push_front(chairOptions.pop_at(typeIndex))
	DropdownPropertyField.putAtFrontOfArray(chairOptions,typeIndex)
	
	#TODO: switch type of chair on each chair
	for chair in chairs:
		pass

#endregion

#region Functions
func addChair():
	pass

func deleteChair():
	pass

func respaceChairs():
	pass
#endregion
