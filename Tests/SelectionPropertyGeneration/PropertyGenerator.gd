extends Object
class_name PropertyGenerator

static func generate(property : Property, connectingObject: DraggableObject) -> PropertyField:
	#I really wanted to transfer this logic to the Property itself, but GDScript can't handle having classes return connectingObjectects of classes that mention the first type of class
	# Generates the PropertyField parallel to the Property in accordance with its specific type
	if property is HeaderProperty:
		return HeaderPropertyField.new(connectingObject,property)
	elif property is SeperatorProperty:
		return SeperatorPropertyField.new(connectingObject,property)
	elif property is DisplayTextProperty:
		return DisplayTextPropertyField.new(connectingObject,property)
	elif property is TextFieldProperty:
		return TextFieldPropertyField.new(connectingObject,property)
	elif property is ParagraphFieldProperty:
		return ParagraphFieldPropertyField.new(connectingObject,property)
	elif property is NumericFieldProperty:
		return NumericFieldPropertyField.new(connectingObject,property)
	elif property is SliderFieldProperty:
		return SliderFieldPropertyField.new(connectingObject, property)
	elif property is CheckToggleProperty:
		return CheckTogglePropertyField.new(connectingObject, property)
	elif property is DropdownProperty:
		return DropdownPropertyField.new(connectingObject, property)
	elif property is DisplayColourProperty:
		return DisplayColourPropertyField.new(connectingObject, property)
	elif property is ColourPickerProperty:
		return ColourPickerPropertyField.new(connectingObject, property)
	else:
		return null
	#when/if I port to GDScript2.0/Godot4, I should be able to put this in Property directly
