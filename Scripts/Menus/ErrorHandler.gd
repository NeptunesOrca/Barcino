extends Control
class_name ErrorHandler

## The error handler group name
const errorHandlerGroupName = "ErrorHandler"
## The sole [ErrorHandler] for handling any and all errors.
static var handler: ErrorHandler = null:
	get:
		return getErrorHandler()

## Returns the [member handler] node, or creates one if one does not already exist.
## Also ensures that the [member handler] node is contained in the current scene
static func getErrorHandler() -> ErrorHandler:
	var sceneTree : SceneTree = SceneTree.current_scene.get_tree()
	
	# Quick(ish) return if we already have an errorhandler set
	if handler!= null:
		# If it's not in the current scene, get it in there 
		if not (handler.is_inside_tree()):
			#Reparent the error handler to the scene tree before returning
			handler.get_parent().remove_child(handler)
			sceneTree.add_child(handler)
		return handler
	
	#Otherwise, we check if there is an error handler node that already exists
	var error_handler_list = sceneTree.get_nodes_in_group(errorHandlerGroupName)
	
	# clear any nodes from the handler group that aren't actually error handlers
	for node in error_handler_list:
		# remove the node from the error handler group if it isn't
		# if we find an error handler, stop looking
		if node is ErrorHandler:
			handler= node
			break
		else:
			node.remove_from_group(errorHandlerGroupName)
	
	# If no error handler has been found, create one
	if (handler== null):
		handler= ErrorHandler.new()
		handler.add_to_group(errorHandlerGroupName)
		sceneTree.current_scene.add_child(handler)
	
	return handler

## Static function to create a new error without needing to find or reference the [member handler]
## [br] Takes in all possible arguments for [method CustomError._init], though does so optionally
static func newError(error_msg := "", error_num := CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER, pushToConsole := true):
	getErrorHandler()
	handler.createNewError(error_msg, error_num, pushToConsole)

## Create a new [CustomError] as a child of the [member handler].
## [br] Takes in all possible arguments for [method CustomError._init], though does so optionally for [param CustomError.error_num] and [param CustomError.pushToConsole]
func createNewError(error_msg : String, error_num := CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER, pushToConsole := true):
	#Create a new error
	var new_error = CustomError.new(error_msg, error_num, pushToConsole)
	self.add_child(new_error)
