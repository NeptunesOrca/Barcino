extends Node
@export var ErrorHandlerTest : ErrorHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ErrorHandlerTesting()
	#ErrorTesting()
	return

func ErrorHandlerTesting():
	#testing that getErrorHandler works as intended, i.e. there is only ever one handler
	var handler = ErrorHandler.handler
	print(handler) #TEST: passed
	var newhandler = ErrorHandler.getErrorHandler()
	print(handler == newhandler) #TEST: passed
	var testmessage = "This is an ErrorHandler test"
	
	#Optional test with manual ErrorHandler that there is only ever one handler (should be at bottom of tree for first execution)
	print(ErrorHandlerTest == handler) #TEST: passed
	
	#testing that both createNewError() and newError() work as intended.
	handler.createNewError(testmessage, CustomError.ErrorTypes.TEST_ERROR)
	ErrorHandler.newError(testmessage, CustomError.ErrorTypes.TEST_ERROR)

func ErrorTesting():
	var test : CustomError
	var testNum
	#Test that errors are generated via ErrorHandler
	var testMessage = "This is an Error test"
	ErrorHandler.newError(testMessage)
	
	#Test that errors without specified error numbers show a title with
	# "ERROR: UNDEFINED ERROR"
	var undef_err_msg
	test = CustomError.new(undef_err_msg)
	testError(test)
	
	#Test that errors with default Error.ErrorTypes.UNDEFINED_ERROR_NUMBER show a title with
	# "ERROR: <ErrorNames[ErrorTypes.UNDEFINED_ERROR_NUMBER]>"
	testNum = CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER
	test = CustomError.new(undef_err_msg, testNum)
	print(CustomError.ErrorNames[testNum])
	testError(test)
	
	#Test that errors with ErrorTypes.TEST_ERROR show a title with
	# "ERROR 0: <ErrorNames[ErrorTypes.TEST_ERROR]>"
	testNum = CustomError.ErrorTypes.TEST_ERROR
	test = CustomError.new(testMessage, testNum)
	print(CustomError.ErrorNames[testNum])
	testError(test)
	
	#Test that errors with numbers not in ErrorTypes show a title with
	# "ERROR <#>: <ErrorNames[ErrorTypes.UNDEFINED_ERROR_NUMBER>
	testNum = INF
	var invalidNumTestMsg = "Invalid number test"
	test = CustomError.new(invalidNumTestMsg, testNum)
	print(CustomError.ErrorNames[CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER])
	testError(test)
	
	#Test that errors with numbers but no names  show a title with
	# "Error <#>: <ErrorNames[ErrorTypes.MISSING_ERROR_NUMBER]><#>
	testNum = CustomError.ErrorTypes.TEST_ERROR_NO_NAME
	var missingErrorNameMsg = "Missing error name test"
	test = CustomError.new(missingErrorNameMsg, testNum)
	print(CustomError.ErrorNames[CustomError.ErrorTypes.MISSING_ERROR_NUMBER], testNum)
	testError(test)
	
	#Test that after errors are closed, they are deleted
	print(test == null)
	return

func testError(test : CustomError):
	self.add_child(test)
	await(test.confirmed)
