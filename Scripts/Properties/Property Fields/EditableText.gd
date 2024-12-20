extends SelectionPropertyField
class_name EditableTextPropertyField
## The [SelectionPropertyField] generated [EditableTextProperty].
##
## Allows the user to interact with the properties of [DraggableObject]s through the [SelectionMenu].
## [br]Executes the definition given by a [EditableTextProperty].
## [br][br]Designed for user-fillable textboxes with only a single line.
## [br][br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when:
## [br] - [EditableTextPropertyField] emits [signal EditableTextPropertyField.sendText] when [member textbox] emits [signal TextEdit.text_changed]

#region Custom Signals
## Custom signal emitted by [method sendText] in response to changes to the value of [member TextEdit.text] in [member textbox].
## [br]Includes the [param text] is the value of [member TextEdit.text] in [member textbox]
signal send_text(text)
#endregion

#region Member Variables
#I think we don't need this anymore
#@export var fontheight = 16
## The [TextEdit] for the [EditableTextPropertyField]
var textbox : TextEdit
## The [Container] that the [member textbox] will go in.
## [br]If [member EditableTextProperty.underLable], will be a [VBoxContainer] to display the elements vertically. Otherwise will be the [EditableTextPropertyField] itself.
var parentContainer : BoxContainer
#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : EditableTextProperty):
	super(obj, property) #calls SelectionPropertyField._init()
	
	# create the textbox
	textbox = TextEdit.new()
	textbox.size_flags_horizontal = SIZE_EXPAND_FILL # will take up whatever space it can after the name
	textbox.text = property.defaultText
	self.size_flags_horizontal = 0
	
	#if putting it on the line below, need to fundamentally rethink the structure of PropertyField for this object type and override it completely
	if (not property.underLable):
		#No need for modifications
		parentContainer = self
	else:
		# We'll make a dummy VBox so we can organize things vertically instead of horizontally, then add everything to the VBox instead
		parentContainer = VBoxContainer.new()
		parentContainer.size_flags_horizontal = SIZE_EXPAND_FILL
		#add parentContainer as a child of this object (which is extended from an HBoxContainer
		self.add_child(parentContainer)
		#now add everything to the VBox container
		#reparent propertyName object to the newly generated parentContainer
		self.remove_child(self.propertyName)
		parentContainer.add_child(self.propertyName)
	#add the textbox to whatever the parent container is
	parentContainer.add_child(textbox)
	fit_to_content_height()
	
	#when the text changes, do what the property specifies
	textbox.text_changed.connect(sendText)
	self.send_text.connect(Callable(obj,property.commandName))
	# we use the custom send_text signal to avoid a mess of getters and setters and to just send the text directly

## Sizes the textbox to 1 line of the determined height
func fit_to_content_height():
	var lines = 1 
	var fontheight = textbox.get_line_height()
	var fontheightspacing = 2
	var linesize = fontheight * getLines() + fontheightspacing
	textbox.custom_minimum_size.y = linesize
#endregion

#region Functions
## Determines the number of lines to be generated
## [br]This is hardcoded to return 1, because if you want multiple lines you should use a ParagraphFieldPropertyField instead
## Could potentially change this in the future to make ParagraphEntry/EditableText a super/subclass of each other, it would certainly be more elegant
func getLines() -> int:
	return 1

## Triggered when the value of [member textbox] changes (i.e. emits [signal TextEdit.text_changed])
## [br]Emits [signal send_text] with the value of [member TextEdit.text] from [member textbox]
func sendText():
	emit_signal("send_text", textbox.text)
#endregion
