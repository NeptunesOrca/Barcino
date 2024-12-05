extends PropertyField
class_name DropdownPropertyField

# Member Variables Here
var dropdown : OptionButton

# Class Initialization
func _init(obj : DraggableObject, property : DropdownProperty).(obj,property):
	#Note that PropertyField will run its initialization before this subclass
	# create the dropdown menu
	dropdown = OptionButton.new()
	dropdown.size_flags_horizontal = SIZE_EXPAND_FILL # let the dropdown menu take up all the extra space after name
	
	#populate the dropdown options
	for item in property.options:
		dropdown.add_item(item)
	
	#add as child
	self.add_child(dropdown)
	
	#connect to object
	dropdown.connect("item_selected", obj, property.onUpdate)

# Other functions, as required
