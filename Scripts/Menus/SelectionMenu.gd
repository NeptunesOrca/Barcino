extends Menu
class_name SelectionMenu

##
const groupName = "SelectionMenu"

##
var selectedObject : DraggableObject

##
@export var propertyStorage : VBoxContainer

#region Startup
##
func _ready():
	add_to_group(groupName)
#endregion

#region Selection and Deselection
##
func select(obj : DraggableObject):
	#Deselect first to clean everything up
	deselect()
	#Select the new object (will handle it's own propertyField generation)
	selectedObject = obj
	selectedObject.select()
	print("Object selected: ", selectedObject)

## Controls the deselection of whatever [DraggableObject] (if any) is currently the [member selectedObject].
## [br] Also deletes all the children property nodes.
func deselect():
	print("Object deselected: ", selectedObject)
	#If no object is selected, early return to save some resources
	if (selectedObject == null):
		return
	
	#Delete all the PropertyField objects that of the selected object
	#See DraggableObject.deselect documentation for reasoning about this
	var currentProperties = self.get_children()
	for child in currentProperties:
		child.queue_free()
	
	#Deselect the object and reset the value of selectedObject
	selectedObject.deselect()
	selectedObject = null
#endregion

#region Adding Properties
##
func addPropertyField(field): #field to be typed as  : PropertyField
	propertyStorage.add_child(field)
#endregion

#region Getters & Setters
## Simple boolean function to tell if the [SelectionMenu] currently has anything selected
func hasSelectedObject() -> bool:
	return (selectedObject != null)
#endregion
