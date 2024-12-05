extends PropertyField
class_name TextFieldPropertyField

# Member Variables Here
# fontheight has to be adjusted manually if changing font type, so can't just do theme changes, can only have one theme
var fontheight = 16 # this has to be hardcoded because getting the font dynamically is stupidly difficult
# this can be changed if we switch to GDScript2.0/GODOT4, or if we store the font used in the theme in the TextFieldProperty
var textbox : TextEdit
var parentContainer : BoxContainer

signal send_text(text)

# Class Initialization
func _init(obj : DraggableObject, property : TextFieldProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# create the textbox
	textbox = TextEdit.new()
	textbox.size_flags_horizontal = SIZE_EXPAND_FILL # will take up whatever space it can after the name
	textbox.text = property.defaultText
	#this just gets overwritten anyhow, so we can just skip it
	#textbox.rect_min_size.y = textbox.get_rect().size.y + 8 # add 8px to the height so that a horizontal scrollbar can go underneath
	self.size_flags_horizontal = 0
	
	#if putting it on the line below, need to fundamentally rethink the structure of PropertyField for this object type and override it completely
	if (not property.isUnder()):
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
	textbox.connect("text_changed",self,"sendText")
	self.connect("send_text",obj,property.onUpdate)
	# we use the custom send_text signal to avoid a mess of getters and setters and to just send the text directly
	
# Other functions, as required
func fit_to_content_height():
	var lines = 1 # this is hardcoded, because if you want multiple lines you should use a ParagraphFieldPropertyField instead
	#I truly don't understand why it's so hard to just get whatever font is being used and then get it's height, but for some reason this really doesn't work
#	if (textbox.theme != null):
#		var textboxfont = textbox.theme.default_font
#		print(textbox.theme.get_font_list())
#		fontsize = textboxfont.get_height()
#	else:
#		fontsize = 16
	var fontheightspacing = 2
	var linesize = fontheight * lines + fontheightspacing
	textbox.rect_min_size.y = linesize

func sendText():
	emit_signal("send_text",textbox.text)
