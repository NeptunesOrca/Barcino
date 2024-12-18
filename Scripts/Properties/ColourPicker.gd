#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name ColourPickerProperty

#region Constants
const DEFAULT_COLOUR = Color.WHITE
#endregion

#region Member Variables
@export var defaultColour : Color :
	get:
		return defaultColour

@export var alphaEnabled : bool :
	get: return alphaEnabled
#endregion

#region Initialization
## Class Initialization
func _init(name: String, command:String, default := DEFAULT_COLOUR, includeAlpha := false):
	super(-1,name, command) #calls SelectionProperty._init()
	defaultColour = default
	alphaEnabled = includeAlpha
#endregion

#region Functions

#endregion
