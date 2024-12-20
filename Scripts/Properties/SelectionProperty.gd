extends Object
class_name SelectionProperty
## The base [SelectionProperty], which provides a framework for generating [SelectionPropertyField]s.
##
## Superclass for different [SelectionPropertu]s. Dictates the generic properties for a generic [SelectionPropertyField], which are specified by subclasses.
## [br]Should be considered an "abstract" superclass, has no utility on its own. 

#region Member Variables
## The name of the [SelectionProperty]. Typically displayed before further information or interactables.
@export var name : String :
	get:
		return name

##Do we even need this anymore?
@export var type : int = -1 :
	get:
		return type

## The [String] name of the command called by the [member SelectionPropertyField.associatedObject] the that should be called when the [SelectionPropertyField] is updated by the user.
## [br]The nature of the commandName will depend on the specifics of the [SelectionProperty] subclass.
@export var commandName : String :
	get:
		return commandName
#endregion

#region Startup
## Class Initialization. Requires [param propType].
func _init(propType, propName := "", onUpdate := ""):
	name = propName
	type = propType
	commandName = onUpdate
	
	#May not need this anymore, trying to get away with not needing propTypes anymore
	# Set propType to -1 (invalid type_ if not one of the possible properties
	#if (type >= PropertyTypes.size() || type < 0):
		#type = -1
#endregion

#region String generation
## Generates the list of member variables and their values, in the form of property: value, seperated by commas. Overridden by subclasses as required.
func generatePropertiesString() -> String:
	return "name: \"" + name + "\", type: " + str(type) + ", commandName: \"" + commandName + "\""

## Returns the name of the class. Overridden by subclasses.
func generateObjectClass() -> String:
	return "SelectionProperty"

## Returns a formatted string with the RID of the [SelectionProperty]
func generateInstanceID() -> String:
	return "#" + str(self.get_instance_id())

## Overrides the _to_string()
func _to_string() -> String:
	return "<" + generateObjectClass() + generateInstanceID() + " ["+ generatePropertiesString() + "] >"
#endregion

#region Generate Property Field
## Returns the [SelectionPropertyField] generated from the definition provided by the [SelectionProperty]. Overrideen by subclasses.
func generate(obj : DraggableObject) -> SelectionPropertyField:
	return null
