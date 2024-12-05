extends PropertyField
class_name DisplayTextPropertyField

# Declare member variables here.
var textbox

func _init(obj : DraggableObject, property : DisplayTextProperty, style : Theme = null).(obj, property):
	# Create the display text
	textbox = Label.new()
	textbox.autowrap = true
	textbox.size_flags_horizontal = SIZE_EXPAND_FILL
	textbox.text = property.text
	self.size_flags_horizontal = 0 # removes the fill flag on the PropertyField, otherwsie the textbox will be too wide
	if (style != null): # can optionally apply a theme here
		textbox.theme = style
	self.add_child(textbox)
	
	# Remove the name if it's flagged as not included
	if (not property.includeName):
		self.propertyName.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
