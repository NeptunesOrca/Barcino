extends Control
class_name ErrorHandler

const errorHandlerGroupName = "ErrorHandler"
const ownscriptpath = "res://Tests/Repopulating by menu parent/ErrorHandler.gd"

# a static function for finding the error handler, or creating one if it does not exist
static func getErrorHandler(someNodeInTree : Node) -> ErrorHandler:
	var sceneTree = someNodeInTree.get_tree()
	var error_handler_node = sceneTree.get_first_node_in_group(errorHandlerGroupName)
	
	# if a node has been found, and that node isn't of the error handler type
	if (error_handler_node != null && ( (error_handler_node.get_script() == null) || (error_handler_node.get_script().resource_path != ownscriptpath))): # this is a hack, but it's the only way to do it.
	#if (error_handler_node != null && ( not (error_handler_node is ErrorHandler)) ) # this is the equivalent but GDScript won't allow self-referencing a the class's script within even a static function
		# I hate how GDScript doesn't actually work as a proper OO language and requires doing this hackiness sometimes
		error_handler_node.remove_from_group(errorHandlerGroupName)
		error_handler_node = null
		
	
	if (error_handler_node == null):
		error_handler_node = load(ownscriptpath).new()
		error_handler_node.add_to_group(errorHandlerGroupName)
		sceneTree.current_scene.add_child(error_handler_node)
		
	return error_handler_node

#Static function that combines both getting the errorHandler and creating a new error in one easy step
static func newError(someNodeInTree : Node, error_msg := "" , error_num := -1):
	var handler = getErrorHandler(someNodeInTree)
	handler.create_new_error(error_msg, error_num)

func create_new_error(error_msg : String, error_num := -1):
	# Create a new error
	var new_error = CustomError.new(error_msg, error_num)
	self.add_child(new_error)
