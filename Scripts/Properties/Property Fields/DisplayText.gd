extends SelectionPropertyField
class_name DisplayTextPropertyField
## The [SelectionPropertyField] generated by [DisplayTextProperty].
##
## Allows the user to interact with the properties of [DraggableObject]s through the [SelectionMenu].
## [br]Executes the definition given by a [DisplayTextProperty].
## [br][br]Designed for displaying text that is not interactable for the user.
## [br][br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] has no effect.

#region Member Variables
## The [Label] that displays the [member DisplayTextProperty.text]
var textbox
#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : DisplayTextProperty, style : Theme = null):
	super(obj, property) #calls SelectionPropertyField._init()
	
	# Create the display text
	textbox = Label.new()
	textbox.autowrap = true
	textbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	textbox.text = property.text
	self.size_flags_horizontal = 0 # removes the fill flag on the PropertyField, otherwsie the textbox will be too wide
	if (style != null): # can optionally apply a theme here
		textbox.theme = style
	self.add_child(textbox)
	
	# Remove the name if it's flagged as not included
	if (not property.includeName):
		self.propertyName.queue_free()
#endregion