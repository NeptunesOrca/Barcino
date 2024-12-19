extends Node
@export var ErrorHandlerTest : ErrorHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until after the first frame to make sure that everything has a chance to properly load first
	call_deferred("testsToCall")

func testsToCall():
	#ErrorHandlerTesting() #TEST: passed DEC13/2024
	#ErrorTesting() #TEST: passed DEC13/2024
	return

func ErrorHandlerTesting(): #TEST: all passed DEC13/2024
	#testing that getErrorHandler works as intended, i.e. there is only ever one handler
	var handler = ErrorHandler.handler
	print(handler) #TEST: passed
	var newhandler = ErrorHandler.getErrorHandler()
	print(handler == newhandler) #TEST: passed
	var testmessage = "This is an ErrorHandler test"	
	
	#Optional test with manual ErrorHandler that there is only ever one handler (should be at bottom of tree for first execution)
	print(ErrorHandlerTest == handler) #TEST: passed
	
	#testing that both createNewError() and newError() work as intended.
	handler.createNewError(testmessage, CustomError.ErrorTypes.TEST_ERROR) #TEST: passed
	ErrorHandler.newError(testmessage, CustomError.ErrorTypes.TEST_ERROR) #TEST: passed

func ErrorTesting(): #TEST: all passed DEC13/2024
	#Setup
	var test : CustomError
	var testNum
	var testReminder = "Title should include: "
	
	#Test that errors are generated via ErrorHandler
	var testMessage = "This is an Error test" #TEST: passed
	ErrorHandler.newError(testMessage)
	await(ErrorHandler.handler.get_child(0).confirmed)
	
	#Test that errors without specified error numbers show a title with
	# "ERROR: UNDEFINED ERROR"
	var undef_err_msg = "This error is not defined" #TEST: passed
	test = CustomError.new(undef_err_msg)
	await(testError(test))
	
	#Test that errors with default Error.ErrorTypes.UNDEFINED_ERROR_NUMBER show a title with
	# "ERROR: <ErrorNames[ErrorTypes.UNDEFINED_ERROR_NUMBER]>"
	testNum = CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER # TEST: passed
	test = CustomError.new(undef_err_msg+" again", testNum)
	print(testReminder,CustomError.ErrorNames[testNum])
	await(testError(test))
	
	#Test that errors with ErrorTypes.TEST_ERROR show a title with
	# "ERROR <ErrorTypes.TEST_ERROR>: <ErrorNames[ErrorTypes.TEST_ERROR]>"
	testNum = CustomError.ErrorTypes.TEST_ERROR # TEST: passed
	test = CustomError.new(testMessage, testNum)
	print(testReminder,CustomError.ErrorNames[testNum])
	await(testError(test))
	
	#Test that errors with numbers not in ErrorTypes show a title with
	# "ERROR <#>: <ErrorNames[ErrorTypes.UNDEFINED_ERROR_NUMBER>
	testNum = INF # TEST: passed
	var invalidNumTestMsg = "Invalid number test"
	test = CustomError.new(invalidNumTestMsg, testNum)
	print(testReminder,CustomError.ErrorNames[CustomError.ErrorTypes.UNDEFINED_ERROR_NUMBER])
	await(testError(test))
	
	#Test that errors with numbers but no names  show a title with
	# "Error <#>: <ErrorNames[ErrorTypes.MISSING_ERROR_NUMBER]><#>
	testNum = CustomError.ErrorTypes.TEST_ERROR_NO_NAME #TEST: not showing the missing error name
	var missingErrorNameMsg = "Missing error name test"
	test = CustomError.new(missingErrorNameMsg, testNum)
	print(testReminder,CustomError.ErrorNames[CustomError.ErrorTypes.MISSING_ERROR_NUMBER], testNum)
	await(testError(test))
	
	#Test that after errors are closed, they are deleted
	await get_tree().process_frame #TEST: passed
	print(test == null)
	return

func testError(test : CustomError): #common test unit for ErrorTesting()
	self.add_child(test)
	await(test.confirmed)
