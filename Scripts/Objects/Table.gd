#meta-name: New DraggableObject
#meta-description: Template for creating a new DraggableObjects
#meta-default: true
extends DraggableObject
class_name Table

#region Constants and Enumerations
## Specifies the shape of the table
enum tableShapeType {
	ROUND, ## Circular tables, such as [CocktailTable]s and [DiwanRoundTable]s
	RECTANGULAR, ## Rectangular tables, such as [PlasticRectangularTable] or [DiwanRectangularTable]
	SEMICIRCULAR ## Specifically for the [IkoinobaSemicircularTable]
}

## The different colour options for linens on tables
enum linenStyle {
	NONE,
	WHITE,
	CREAM,
	BLACK,
	GREEN,
}

## The display colours corresponding to each [enum linenStyle]
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
#var sizeInfoHeaderProp = HeaderProperty.new("Size")

var dimensions : TableDim
var shape : tableShapeType

var d_or_l_dimensionalProp : DisplayTextProperty
var w_dimensionalProp : DisplayTextProperty

var sizeSep = SeperatorProperty.new("Size Seperators")
var sizeProps
#endregion

#region Chairs
var chairHeaderProp = HeaderProperty.new("Chair Options")

var totalChairs : int = 0 #TODO: switch this to being chairs.length
var chairs #TODO: switch this to being an actual number of chair children of the table
var chairType #TODO specify with enum from Chair class
#var evenChairSpacing : bool
var maxchairs : int

var chairsNumProp = NumericEntryProperty.new("Chairs", "changeChairNumber", totalChairs, 0, maxchairs)
var chairOptions : Array = [] #TODO specify with enum from Chair class
var chairTypeProp = DropdownProperty.new("Chair Type", "changeChairType", chairOptions)

var chairSep = SeperatorProperty.new("Chair Option Seperator")
var chairProperties = [chairHeaderProp, chairsNumProp, chairTypeProp]
#endregion

#region Linens
var linenHeaderProp = HeaderProperty.new("Linen Options")

var hasLinen : bool = false
var linenType : linenStyle
var linenOptions : Array = linenStyle.keys()

var linenTypeProp = DropdownProperty.new("Linen Type", "changeLinen", linenOptions)
var linenColourDisplayProp = DisplayColourProperty.new("Linen Colour","",linenColour[linenStyle.NONE],DisplayColourProperty.NORMAL_SIZE,true,false)

var linenSep = SeperatorProperty.new("Linen Seperator")
var linenProperties = [linenHeaderProp, linenTypeProp, linenColourDisplayProp, linenSep]
#endregion
#endregion
#endregion

#region Class Initialization
## Class Initialization. Requires [param tableshape] as one of the valid [enum tableShapeType]s, and [param dims] as an appropriately defined [TableDim] (see below for more information).
## [br] Takes in the descriptive [param typeName] to describe the what the class is (e.g. "Diwan Table", "Ikoi-no-ba Chair", "Speaker" etc.), defaulting to "Table", but can be overridden by subclasses.
## [br] Also takes in the [param maximumChairs] that can fit around the table. Defaults to 8, but can be overridden by subclasses.
## [br][br] [b]Appropriately defined [TableDim] guidance[/b]
## [br] If [param tableshape] is [enum tableShapeType.RECTANGULAR], will need both a [method TableDim.length] and [method TableDim.width].
## [br] If [param tableshape] is [enum tableShapeType.ROUND], will only need a [method TableDim.diameter]. [method TableDim.radius]/[method TableDim.width] is unused and ignored.
## [br] If [param tableshape] is [enum tableShapeType.SEMICIRCULAR], will need to define [method TableDim.diameter], though it will not be used directly. [method TableDim.radius] will be automatically calculated, and used. [method TableDim.width] is ignored
func _init(tableshape : tableShapeType, dims : TableDim, typeName : String = "Table", maximumChairs : int = 8):
	maxchairs = maximumChairs
	shape = tableshape
	dimensions = dims
	
	# Generate the dimensional selection properties
	var unit = "'"
	match shape:
		tableShapeType.RECTANGULAR:
			d_or_l_dimensionalProp = DisplayTextProperty.new("Length",str(dimensions.length()) + unit)
			w_dimensionalProp = DisplayTextProperty.new("Width", str(dimensions.width()) + unit)
		tableShapeType.ROUND:
			d_or_l_dimensionalProp = DisplayTextProperty.new("Diameter",str(dimensions.diameter())+unit)
		tableShapeType.SEMICIRCULAR:
			w_dimensionalProp = DisplayTextProperty.new("Radius",str(dimensions.radius())+unit)
	
	super(typeName) #need this afterwards to that the dimensionProp are properly generated
	
## Collects all the [SelectionProperty]s to be put in the [member propertyList] during [method _init].
## [br] Overrides [method DraggableObject.collectProperties].
func collectProperties():
	super()
	
	sizeProps = [d_or_l_dimensionalProp, w_dimensionalProp, sizeSep]
	propertyList.append_array(sizeProps)
	propertyList.append_array(chairProperties)
	propertyList.append_array(linenProperties)
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
	
	propertyFieldList[linenColourDisplayProp.name].updateColour(linenColour[linenType])

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
#region Adjust Chairs
func addChair():
	pass

func deleteChair():
	pass

func respaceChairs():
	pass
#endregion

#region Display Units
# maybe someday
#func displayMetric():
	#pass
#
#func displayImperial():
	#pass
#endregion
#endregion
