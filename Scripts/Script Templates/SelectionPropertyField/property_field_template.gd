#meta-name: New SelectionPropertyField
#meta-description: Template for creating a new PropertyFields. Will automatically append "PropertyField" to the end of whatever name is given
#meta-default: true
extends SelectionPropertyField
class_name _CLASS_PropertyField

#region Member Variables

#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : _CLASS_Property):
	super(obj, property) #calls SelectionPropertyField._init()

#end region

#region Functions

#endregion