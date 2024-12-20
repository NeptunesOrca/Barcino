extends HBoxContainer
class_name SelectionPropertyField

#region Constants
## The minimum width of the [SelectionPropertyField], which should be equal to the width of the PropertyFieldContainer of the [SelectionMenu] that the [SelectionProeprtyField] is to be added to
## Set to [code]176[/code].
const minwidth = 200 -24
## The minimum height of the [SelectionPropertyField].
## [br]Set to [code]0[/code].
const minheight = 0
#endregion

#region Member Variables
## The corresponding [SelectionProperty] that defines how this [SelectionPropertyField] should behave.
var definition : SelectionProperty
## The [DraggableObject] that this [SelectionPropertyField] is connected to.
## This [SelectionPropertyField] should appear within the [member DraggableObject.propertyFieldList] of the [member associatedObject].
var associatedObject : DraggableObject
## The [Label] used to show the [member SelectionProperty.name] of the [member definition] of this [SelectionPropertyField].
## [br]May be deleted by some subclasses.
var propertyName : Label
#endregion

#region Initialization
## SelectionPropertyField Initialization
func _init(obj: DraggableObject, prop : SelectionProperty):
	#Note that a subclass will run its initialization AFTER the superclass
	
	# Setup the member variables
	definition = prop
	associatedObject = obj
	
	# Setup the HBoxContainer boundaries
	self.custom_minimum_size = Vector2(minwidth, minheight)
	
	# Generate name label
	var text = definition.name + ":"
	propertyName = Label.new()
	propertyName.text = text
	self.add_child(propertyName)
#endregion

func getNameObject():
	return propertyName

func getDefinition() -> SelectionProperty:
	return definition
# Other functions, as required
