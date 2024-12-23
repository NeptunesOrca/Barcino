extends Node

#@export
var ErrorHandlerTest : ErrorHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until after the first frame to make sure that everything has a chance to properly load first
	call_deferred("testsToCall")

func testsToCall():
	#ErrorHandlerTesting() #TEST: passed DEC13/2024
	#ErrorTesting() #TEST: passed DEC13/2024
	#SelectionPropertiesAndFieldsTesting() #TEST: passed DEC13/2024
	return

func SelectionPropertiesAndFieldsTesting(): #TEST: passed DEC13/2024
	var testObj = testSelectionObject.new()
	var layout = $"../Venue"
	layout.add_child(testObj)
	await get_tree().process_frame
	#testObj.selectionMenu.select(testObj)
	var selectionMenu = testObj.selectionMenu
	selectionMenu.select(testObj)
	print(testObj, " selected.")

class testSelectionObject extends DraggableObject:
	#region test properties and propertyfields
	var headerTest = HeaderProperty.new("Test Header") #TEST: passed Dec20/2024
	var seperatorTest = SeperatorProperty.new("testname") #TEST: passed Dec20/2024
	var displayTextTest1 = DisplayTextProperty.new("Display Text 1", "Lorem ipsum", true) #TEST: passed Dec20/2024
	var displayTextTest2 = DisplayTextProperty.new("Display Text 2", "dolor sic amet", false) #TEST: passed Dec20/2024
	var staticTests = [headerTest, seperatorTest, displayTextTest1, displayTextTest2]
	
	var checkTest = CheckToggleProperty.new("Test Check", "toggleCheck") #TEST: passed DEC20/2024
	var checkTests = [checkTest]
	
	var colourPickTest = ColourPickerProperty.new("Colour Test", "colourCheck") #TEST: passed DEC20/2024
	var displayColourTest1 = DisplayColourProperty.new("Display Colour Test 1", "colourCheck", DisplayColourProperty.DEFAULT_WHITE, DisplayColourProperty.SMALL_SIZE, false, true) #TEST: passed Dec20/2024
	var displayColourTest2 = DisplayColourProperty.new("Display Colour Test 2", "colourCheck", Color.BLUE, DisplayColourProperty.LARGE_SIZE, true, false) #TEST: passed Dec20/2024
	var colourTests = [colourPickTest, displayColourTest1, displayColourTest2]
	
	var dropdownOptions = [0, "Option 1", 2, "Option 3"]
	var dropdownTest = DropdownProperty.new("Dropdown Test", "dropdownCheck", dropdownOptions) #TEST: passed Dec20/2024
	var dropdownTests = [dropdownTest]
	
	var textboxTest1 = EditableTextProperty.new("Textbox test 1", "textCheck", "Lorem ipsum", false) #TEST: passed Dec20/2024
	var textboxTest2 = EditableTextProperty.new("Textbox test 2", "textCheck", "dolor sic ament", true) #TEST: passed Dec20/2024
	var paragraphTest1 = ParagraphEntryProperty.new("Paragraph test 1", "textCheck", "Lorem", 1) #TEST: passed Dec20/2024
	var paragraphTest2 = ParagraphEntryProperty.new("Paragraph test 2", "textCheck", "ipsum", 2) #TEST: passed Dec20/2024
	var paragraphTest3 = ParagraphEntryProperty.new("Paragraph test 3", "textCheck", "dolor", 3) #TEST: passed Dec20/2024
	var paragraphTest4 = ParagraphEntryProperty.new("Paragraph test 4", "textCheck", "sic amet", 5) #TEST: passed Dec20/2024
	var textTests = [textboxTest1, textboxTest2, paragraphTest1, paragraphTest2, paragraphTest3, paragraphTest4]
	
	var numericTest1 = NumericEntryProperty.new("Numeric test 1", "numCheck", 0, NumericEntryProperty.NO_MINIMUM, NumericEntryProperty.NO_MAXIMUM, 0) #TEST: passed Dec20/2024
	var numericTest2 = NumericEntryProperty.new("Numeric test 2", "numCheck", 0.5, 0, 1, 3, "Some prefix", "/post") #TEST: passed Dec20/2024
	var numTests = [numericTest1, numericTest2]
	
	var sliderTest1 = SliderProperty.new("Slider test 1", "numCheck", 0) #TEST: passed Dec20/2024
	var sliderTest2 = SliderProperty.new("Slider test 2", "numCheck", 50, 0, 100) #TEST: passed Dec20/2024
	var sliderTest3 = SliderProperty.new("Slider test 3", "numCheck", 0, SliderProperty.DEFAULT_MINVAL, SliderProperty.DEFAULT_MAXVAL, 2) #TEST: passed Dec20/2024
	var sliderTest4 = SliderProperty.new("Slider test 4", "numCheck", 0, SliderProperty.DEFAULT_MINVAL, SliderProperty.DEFAULT_MAXVAL, SliderProperty.AUTO_TICKS, 25) #TEST: passed Dec20/2024
	var sliderTest5 = SliderProperty.new("Slider test 5", "numCheck", 0, SliderProperty.DEFAULT_MINVAL, SliderProperty.DEFAULT_MAXVAL, SliderProperty.AUTO_TICKS, SliderProperty.DEFAULT_STEPSIZE, SliderProperty.MaxMinOverride.BOTH_OVER_AND_UNDER) #TEST: passed Dec20/2024
	var sliderAdjusterTest = NumericEntryProperty.new("Change slider 5", "sliderAdjust", sliderTest5.defaultValue, NumericEntryProperty.NO_MINIMUM, NumericEntryProperty.NO_MAXIMUM, 1) #TEST: passed Dec20/2024
	var sliderTests = [sliderTest1, sliderTest2, sliderTest3, sliderTest4, sliderTest5, sliderAdjusterTest]
	
	var propertyTests = [staticTests, checkTests, colourTests, dropdownTests, textTests, numTests, sliderTests]
	#endregion
	
	func _ready():
		super()
		for testList in propertyTests:
			propertyList.append_array(testList)
	
	func toggleCheck(boolval : bool):
		print("Bool value: ",boolval)
	
	func colourCheck(colourval : Color):
		print("Colour Value: ", colourval)
	
	func dropdownCheck(val : int):
		print("Option selected: ", val, " -> ", dropdownOptions[val])
	
	func textCheck(text : String):
		print("Text value: ", text)
	
	func numCheck(val):
		print("Number value: ", val)
	
	func sliderAdjust(val):
		print("Slider5 should have value of: ", val)
		propertyFieldList[sliderTest5.name].getSlider().value = val

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
