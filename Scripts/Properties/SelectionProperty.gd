extends Object
class_name SelectionProperty
## 
##
## 
 
@export var name : String :
	get:
		return name

#Do we even need this anymore?
@export var type : int = -1 :
	get:
		return type

@export var commandName : String :
	get:
		return commandName

func _init(propType, propName := "", onUpdate := ""):
	name = propName
	type = propType
	commandName = onUpdate
	
	# Set propType to -1 (invalid type_ if not one of the possible properties
	#if (type >= PropertyTypes.size() || type < 0):
		#type = -1
