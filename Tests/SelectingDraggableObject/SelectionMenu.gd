extends VBoxContainer

var selectedObject : SelectableObject

func select(obj : SelectableObject):
	deselect()
	selectedObject = obj
	selectedObject.select()
	
func deselect():
	if (selectedObject == null):
		return
	
	var currentProperties = self.get_children()
	for child in currentProperties:
		child.queue_free()
	
	selectedObject.deselect()
	selectedObject = null
	print("deselected")
	
func hasSelectedObject() -> bool :
	return (selectedObject != null)
