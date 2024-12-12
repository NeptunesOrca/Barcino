extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ErrorHandlerTesting()
	ErrorTesting()

func ErrorHandlerTesting():
	var handler = ErrorHandler.handler
	print(handler)
	var newhandler = ErrorHandler.getErrorHandler()
	print(handler == newhandler)

func ErrorTesting():
	var testError
	
	return
