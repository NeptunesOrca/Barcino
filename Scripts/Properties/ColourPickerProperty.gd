extends SelectionProperty
class_name ColourPickerProperty
## The [SelectionProperty] used to generate [ColourPickerPropertyField].
##
## Dictates the properties of a [ColourPickerPropertyField].
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when:
## [br] - [ColorPicker] of the [ColourPickerPropertyField] emits [signal ColorPicker.color_changed]

#region Constants
## The default value for the [member ColorPicker.color] of the [ColourPickerPropertyField] if the [member defaultColour] is not specified.
## [br]Set to [contant Color.WHITE]
const DEFAULT_COLOUR = Color.WHITE
#endregion

#region Member Variables
## The default value for the [member ColorPicker.color] of the [ColourPickerPropertyField].
## [br]Set to [constant DEFAULT_COLOUR] by default.
@export var defaultColour : Color :
	get:
		return defaultColour

## Whether the [member ColorPicker.edit_alpha] of the [ColourPickerPropertyField] should be enabled.
## [br]Set to [code]false[/code] by default.
@export var alphaEnabled : bool :
	get: return alphaEnabled
#endregion

#region Initialization
## Class Initialization. Requires [param name] and [param command].
## [br]Defaults [param default] to [constant DEFAULT_COLOUR] for [member defaultColour]
## [br]Defaults [param includeAlpha] to [code]false[/code] for [member alphaEnabled]
func _init(name: String, command:String, default := DEFAULT_COLOUR, includeAlpha := false):
	super(-1,name, command) #calls SelectionProperty._init()
	defaultColour = default
	alphaEnabled = includeAlpha
#endregion

#region String Generation Overrides
## Generates the list of member variables and their values, in the form of property: value, seperated by commas
func generatePropertiesString() -> String:
	return super() + ", defaultColour: " + str(defaultColour) + ", alphaEnabled: " + str(alphaEnabled)

## Returns the name of the class. Overrides [method SelectionProperty.generateObjectClass].
func generateObjectClass() -> String:
	return "ColourPickerProperty"
#endregion

#region Generate Property Field
## Returns the [ColourPickerPropertyField] generated from the definition provided by the [ColourPickerProperty].
func generate(obj : DraggableObject) -> SelectionPropertyField :
	return ColourPickerPropertyField.new(obj, self)
#endregion
