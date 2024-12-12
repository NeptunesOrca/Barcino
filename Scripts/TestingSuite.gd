extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ErrorHandlerTesting()
	ErrorTesting()
	return

func ErrorHandlerTesting():
	#testing that getErrorHandler works as intended, i.e. there is only ever one handler
	var handler = ErrorHandler.handler
	print(handler)
	var newhandler = ErrorHandler.getErrorHandler()
	print(handler == newhandler)
	var testmessage = "This is an ErrorHandler test"
	
	#testing that both createNewError() and newError() work as intended.
	handler.createNewError(testmessage, Error.ErrorTypes.TEST_ERROR)
	ErrorHandler.newError(testmessage, Error.ErrorTypes.TEST_ERROR)

func ErrorTesting():
	var test : Error
	var testNum
	#Test that errors are generated via ErrorHandler
	var testMessage = "This is an Error test"
	ErrorHandler.newError(testMessage)
	
	#Test that errors without specified error numbers show a title with
	# "ERROR: UNDEFINED ERROR"
	var undef_err_msg
	test = Error.new(undef_err_msg)
	testError(test)
	
	#Test that errors with default Error.ErrorTypes.UNDEFINED_ERROR_NUMBER show a title with
	# "ERROR: <ErrorNames[ErrorTypes.UNDEFINED_ERROR_NUMBER]>"
	testNum = Error.ErrorTypes.UNDEFINED_ERROR_NUMBER
	test = Error.new(undef_err_msg, testNum)
	print(Error.ErrorNames[testNum])
	testError(test)
	
	#Test that errors with ErrorTypes.TEST_ERROR show a title with
	# "ERROR 0: <ErrorNames[ErrorTypes.TEST_ERROR]>"
	testNum = Error.ErrorTypes.TEST_ERROR
	test = Error.new(testMessage, testNum)
	print(Error.ErrorNames[testNum])
	testError(test)
	
	#Test that errors with numbers not in ErrorTypes show a title with
	# "ERROR <#>: <ErrorNames[ErrorTypes.UNDEFINED_ERROR_NUMBER>
	testNum = INF
	var invalidNumTestMsg = "Invalid number test"
	test = Error.new(invalidNumTestMsg, testNum)
	print(Error.ErrorNames[Error.ErrorTypes.UNDEFINED_ERROR_NUMBER])
	testError(test)
	
	#Test that errors with numbers but no names  show a title with
	# "Error <#>: <ErrorNames[ErrorTypes.MISSING_ERROR_NUMBER]><#>
	testNum = Error.ErrorTypes.TEST_ERROR_NO_NAME
	var missingErrorNameMsg = "Missing error name test"
	test = Error.new(missingErrorNameMsg, testNum)
	print(Error.ErrorNames[Error.ErrorTypes.MISSING_ERROR_NUMBER], testNum)
	testError(test)
	
	#Test that after errors are closed, they are deleted
	print(test == null)
	return

func testError(test : Error):
	self.add_child(test)
	await(test.confirmed)
