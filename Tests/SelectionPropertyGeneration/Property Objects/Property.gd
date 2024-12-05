extends Object
class_name Property

export(String) var propName setget noChange, getName
export(int) var propType := -1 setget noChange, getType
export(String) var onUpdate setget noChange, getCommandName

enum PropertyTypes {
		HEADER_PROPERTY, 			# uses name is aliased as header, done as subclass
		SEPERATOR_PROPERTY, 		# ignores name and command, done as subclass
		DISPLAY_TEXT_PROPERTY, 		# done as subclass
		TEXT_FIELD_PROPERTY, 		# done as subclass
		PARAGRAPH_FIELD_PROPERTY,	# done as subclass
		NUMERIC_FIELD_PROPERTY, 	# done as subclass
		SLIDER_PROPERTY,			# done as subclass
		CHECK_TOGGLE_PROPERTY,		# done as subclass
		DROPDOWN_PROPERTY,			# done as subclass
		DISPLAY_COLOUR_PROPERTY, 	# done as subclass
		COLOUR_PICKER_PROPERTY		# done as subclass
		}

func _init(type, name := "", commandName := ""):
	propName = name
	propType = type
	onUpdate = commandName
	
	# Set propType to -1 (invalid type) if it is not one of the possible properties
	if (type >= PropertyTypes.size() || type < 0):
		propType = -1

func noChange(_value):
	pass

func getName():
	return propName

func getType():
	return propType

func getCommandName():
	return onUpdate

#I really wanted to transfer this logic to the Property itself, but GDScript can't handle having classes return objects of classes that mention the first type of class
#static func generateField(obj: DraggableObject, property : Property):
#	match property.propType:
#		Property.PropertyTypes.HEADER_PROPERTY:
#			return HeaderPropertyField.new(obj, property) # This breaks it, because GDScript thinks this is a circular dependence
			# GDScript cannot handle loading a script and just saying "oh yeah, this has to return or receive an object of some type of class, throw an error if it doesn't match that type" without having previously loaded the entire class
			# Sometimes, I really hate GDScript
#			#newPropField = property.generateField()
#		Property.PropertyTypes.DISPLAY_TEXT_PROPERTY:
#			pass
#		Property.PropertyTypes.TEXT_FIELD_PROPERTY:
#			pass
#		Property.PropertyTypes.PARAGRAPH_FIELD_PROPERTY:
#			pass
#		Property.PropertyTypes.NUMERIC_FIELD_PROPERTY:
#			pass
#		Property.PropertyTypes.SLIDER_PROPERTY:
#			pass
#		Property.PropertyTypes.CHECK_TOGGLE_PROPERTY:
#			pass
#		Property.PropertyTypes.DROPDOWN_PROPERTY:
#			pass
#		Property.PropertyTypes.STATIC_COLOUR_PROPERTY:
#			pass
#		Property.PropertyTypes.COLOUR_PICKER_PROPERTY:
#			pass
