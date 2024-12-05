extends PropertyField
class_name ParagraphFieldPropertyField

# Member Variables Here
var textbox : TextEdit
var parentContainer : BoxContainer
var fontheight = 16

signal send_text(text)

# Class Initialization
func _init(obj : DraggableObject, property : ParagraphFieldProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# create the textbox
	textbox = TextEdit.new()
	textbox.size_flags_horizontal = SIZE_EXPAND_FILL # will take up whatever space it can after the name
	textbox.text = property.defaultText
	textbox.wrap_enabled = true
	self.size_flags_horizontal = 0
	
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
	textbox.connect("text_changed",self,"sendText")
	self.connect("send_text",obj,property.onUpdate)
	# we use the custom send_text signal to avoid a mess of getters and setters and to just send the text directly

# Other functions, as required
func match_height_to_lines():
	var fontheightspacing = 2
	textbox.rect_min_size.y = (fontheight + fontheightspacing) * self.definition.lines

func sendText():
	emit_signal("send_text",textbox.text)
