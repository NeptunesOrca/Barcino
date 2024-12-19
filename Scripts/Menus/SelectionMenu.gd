extends Menu
class_name SelectionMenu

## The group name for [SelectionMenu] so that it can easily be found by other nodes
const groupName = "SelectionMenu"

## The [DraggableObject] that is currently selected.
var selectedObject : DraggableObject

## The [VBoxContainer] that stores the [SelectionPropertyField]s associated with the [member selectedObject]
@export var propertyStorage : VBoxContainer

#region Startup
## Called when the node enters the scene tree for the first time.
## Adds the [member groupName] to this node so it can be easily found by other nodes.
func _ready():
	add_to_group(groupName)
#endregion

#region Selection and Deselection
## Selects the [param obj] passed in the call.
## [br] Always calls [method deselect] before doing anything else.
## [br] Uses [method DraggableObject.select].
func select(obj : DraggableObject):
	#Deselect first to clean everything up
	deselect()
	#Select the new object (will handle it's own SelectionPropertyField generation)
	selectedObject = obj
	selectedObject.select()

## Controls the deselection of whatever [DraggableObject] (if any) is currently the [member selectedObject].
## [br] Also deletes all the children property nodes.
func deselect():
	#If no object is selected, early return to save some resources
	if (selectedObject == null):
		return
	
	#Delete all the SelectionPropertyField objects that of the selected object
	#See DraggableObject.deselect documentation for reasoning about this
	var currentProperties = self.get_children()
	for child in currentProperties:
		child.queue_free()
	
	#Deselect the object and reset the value of selectedObject
	selectedObject.deselect()
	selectedObject = null
#endregion

#region Adding Properties
## Adds a provided [SelectionPropertyField] to the [member propertyStorage] for the user to use.
func addPropertyField(field): #TODO field to be typed as  : SelectionPropertyField
	propertyStorage.add_child(field)
#endregion

#region Getters & Setters
## Simple boolean function to tell if the [SelectionMenu] currently has anything selected
func hasSelectedObject() -> bool:
	return (selectedObject != null)
#endregion
