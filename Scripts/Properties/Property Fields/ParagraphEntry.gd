#meta-name: New SelectionPropertyField
#meta-description: Template for creating a new PropertyFields. Will automatically append "PropertyField" to the end of whatever name is given
#meta-default: true
extends SelectionPropertyField
class_name ParagraphEntryPropertyField
## The [SelectionPropertyField] generated by [ParagraphEntryProperty].
##
## Allows the user to interact with the properties of [DraggableObject]s through the [SelectionMenu].
## [br]Executes the definition given by a [ParagraphEntryProperty].
## [br][br]Designed for user-fillable textboxes with only multiple lines.
## [br][br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when:
## [br] - [ParagraphEntryPropertyField] emits [signal ParagraphEntryPropertyField.sendText] when [member textbox] emits [signal TextEdit.text_changed]

#region Custom Signals
## Custom signal emitted by [method sendText] in response to changes to the value of [member TextEdit.text] in [member textbox].
## [br]Includes the [param text] is the value of [member TextEdit.text] in [member textbox]
signal send_text(text)
#endregion

#region Member Variables
## The [TextEdit] for the [EditableTextPropertyField]
var textbox : TextEdit
## The [Container] that the [member textbox] will go in.
## [br]A [VBoxContainer] to display the elements vertically.
var parentContainer : BoxContainer
#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : ParagraphEntryProperty):
	super(obj, property) #calls SelectionPropertyField._init()
	
	# create the textbox
	textbox = TextEdit.new()
	textbox.size_flags_horizontal = SIZE_EXPAND_FILL # will take up whatever space it can after the name
	textbox.text = property.defaultText
	textbox.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# create a dummy vBox so that we can stack elements vertically instead of horizontally
	parentContainer = VBoxContainer.new()
	parentContainer.size_flags_horizontal = SIZE_EXPAND_FILL
	self.add_child(parentContainer)
	#restack the name within the parentContainer
	self.remove_child(self.propertyName)
	parentContainer.add_child(self.propertyName)
	# add the textbox to the container
	parentContainer.add_child(textbox)
	match_height_to_lines()
	
	#when the text changes, do what the property specifies
	textbox.text_changed.connect(sendText)
	self.send_text.connect(Callable(obj,property.commandName))
	# we use the custom send_text signal to avoid a mess of getters and setters and to just send the text directly

## Sizes the textbox to the specified number of line of the determined height
func match_height_to_lines():
	var fontheightspacing = 2
	var fontheight = textbox.get_line_height()
	textbox.custom_minimum_size.y = (fontheight + fontheightspacing) * self.definition.lines
#endregion

#region Functions
## Triggered when the value of [member textbox] changes (i.e. emits [signal TextEdit.text_changed])
## [br]Emits [signal send_text] with the value of [member TextEdit.text] from [member textbox]
func sendText():
	emit_signal("send_text",textbox.text)
#endregion
