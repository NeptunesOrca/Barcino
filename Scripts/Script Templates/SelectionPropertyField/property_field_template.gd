#meta-name: New SelectionPropertyField
#meta-description: Template for creating a new PropertyFields. Will automatically append "PropertyField" to the end of whatever name is given
#meta-default: true
extends SelectionPropertyField
class_name _CLASS_PropertyField
## The [SelectionPropertyField] generated by [_CLASS_Property].
##
## Allows the user to interact with the properties of [DraggableObject]s through the [SelectionMenu].
## [br]Executes the definition given by a [_CLASS_Property].[br]
## [br]The function [member SelectionProperty.commandName] of the [member SelectionPropertyField.associatedObject] will be called when:
## [br] - [member %object%] emits [signal %object%.%signal%]

#region Member Variables

#endregion

#region Initialization
## Class Initialization
func _init(obj : DraggableObject, property : _CLASS_Property):
	#generate any properties here first, so that they will be properly added by collectProperties() when super() is called
	super(obj, property) #calls SelectionPropertyField._init()
	
#endregion

#region Functions

#endregion