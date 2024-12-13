extends Control
class_name ErrorHandler

## The error handler group name
const errorHandlerGroupName = "ErrorHandler"
## The sole [ErrorHandler] for handling any and all errors.
static var handler: ErrorHandler = null:
	get = getErrorHandler

## Returns the [member handler] node, or creates one if one does not already exist.
## Also ensures that the [member handler] node is contained in the current scene
static func getErrorHandler() -> ErrorHandler:
	var sceneTree : SceneTree = Engine.get_main_loop()
	#ALERT: Need some way of making sure that the SceneTree actually has a current scene
	#var sceneTree = someNodeInTree.get_tree()
	
	# Quick(ish) return if we already have an errorhandler set
	if handler!= null:
		# If it's not in the current scene, get it in there 
		if not (handler.is_inside_tree()):
			#Reparent the error handler to the scene tree if necessary before returning
			var parent = handler.get_parent()
			if (parent != null):
				handler.get_parent().remove_child(handler)
			sceneTree.current_scene.add_child(handler)
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
	if (handler == null):
		handler = ErrorHandler.new()
		handler.add_to_group(errorHandlerGroupName)
		sceneTree.current_scene.add_child(handler)
	
	print(sceneTree.current_scene)
	print(sceneTree.root)
	print(sceneTree.current_scene.get_children())
	
	return handler

## Static function to create a new error without needing to find or reference the [member handler]
## [br] Takes in all possible arguments for [method Error._init], though does so optionally
static func newError(error_msg := "", error_num := CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER, pushToConsole := true):
	getErrorHandler()
	handler.createNewError(error_msg, error_num, pushToConsole)

## Create a new [Error] as a child of the [member handler].
## [br] Takes in all possible arguments for [method Error._init], though does so optionally for [param Error.error_num] and [param Error.pushToConsole]
func createNewError(error_msg : String, error_num := CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER, pushToConsole := true):
	#Create a new error
	var new_error = CustomError.new(error_msg, error_num, pushToConsole)
	self.add_child(new_error)
	#var new_popup = AcceptDialog.new()
	#self.add_child(new_popup)
	#print(self.is_visible())
	#new_popup.popup_centered()
	#print(new_popup.is_visible())
