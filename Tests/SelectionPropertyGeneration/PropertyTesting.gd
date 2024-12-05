extends Node

const selectionMenuName = "SelectionMenu"

var standardizedOptionsList = ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

class testObj extends DraggableObject:
	var options
	func _init(optionsList):
		options = optionsList
		
	func testText(string : String):
		print(string)
	func testNum(num):
		print(num)
	func testBool(val : bool):
		print(val)
	func testColour(colour : Color):
		print(colour)
	func testOptionsList(index : int):
		print(options[index])

func _ready():
	testPropertyGeneration()

func testPropertyGeneration():
	var obj = testObj.new(standardizedOptionsList)
	
	var headerTest = HeaderProperty.new("Test Header")
	var headerTests = [headerTest]
	# all header tests working
	
	var lineTest = SeperatorProperty.new()
	var lineTests = [lineTest]
	#all seperator tests working
	
	var onelineDisplayTest = DisplayTextProperty.new("Some Name", "some display text", true)
	var noNameDisplayTest = DisplayTextProperty.new("Some Name 2", "some display text 2", false)
	var multilineDisplayTest = DisplayTextProperty.new("Some Name 3", "this is a  lot of display text that should probably go across multiple lines and if it does not that will be a bit of a problem")
	var displayTextTests = [onelineDisplayTest, noNameDisplayTest, multilineDisplayTest]
	#all display text tests working
	
	var underlableTest = TextFieldProperty.new("TextFieldName1", "testText", "default", true)
	var levelLabelTest = TextFieldProperty.new("TextFieldName2", "testText", "default2")
	var TextEditTests = [underlableTest, levelLabelTest]
	#all text field tests working
	
	var oneLineTest = ParagraphFieldProperty.new("Paragraph1", "testText", "default", 1)
	var threeLineTest = ParagraphFieldProperty.new("Paragraph2", "testText", "line1\nline2\nline3", 3)
	var eightLineTest = ParagraphFieldProperty.new("Paragraph3","testText","line1\nline2\nline3\nline4\nline5\nline6\nline7\nline8",8)
	var longDefaultTest = ParagraphFieldProperty.new("Paragraph4","testText","this is a  lot of display text that should probably go across multiple lines and if it does not that will be a bit of a problem",3)
	var ParagraphTests = [oneLineTest, threeLineTest, eightLineTest, longDefaultTest]
	#all paragraph tests working
	
	var intTest = NumericFieldProperty.new("Num1", "testNum", 0, -INF, INF, 0)
	var minTest = NumericFieldProperty.new("Num2", "testNum", 0, 0)
	var maxTest = NumericFieldProperty.new("Num3", "testNum", 0, -INF, 10)
	var twodecimalTest = NumericFieldProperty.new("Num4", "testNum", 0, -INF, INF, 2)
	var otherDefaultTest = NumericFieldProperty.new("Num5", "testNum", 1)
	var NumberTests = [intTest, minTest, maxTest, twodecimalTest, otherDefaultTest]
	#all numbox tests working
	
	var sliderTest1 = SliderFieldProperty.new("Slider1", "testNum")
	var sliderMin = SliderFieldProperty.new("Slider2", "testNum", 0, 0)
	var sliderMax = SliderFieldProperty.new("Slider3", "testNum", 0, SliderFieldProperty.NO_MINIMUM, 10)
	var sliderCustomTicks = SliderFieldProperty.new("Slider4", "testNum", 0, 0, 10, 4)
	var sliderNoCustomTicks = SliderFieldProperty.new("Slider5", "testNum", 0, 0, 10, SliderFieldProperty.AUTO_TICKS, 0.1)
	var sliderCapMaxMin = SliderFieldProperty.new("Slider6", "testNum", 0, 0, 10, SliderFieldProperty.AUTO_TICKS, SliderFieldProperty.DEFAULT_STEPSIZE, SliderFieldProperty.NO_OVERRIDE)
	var sliderCustomTicksWithOverflow = SliderFieldProperty.new("Slider7", "testNum", 0, 0, 12, 4, SliderFieldProperty.DEFAULT_STEPSIZE, SliderFieldProperty.OVERRIDE_OVER_AND_UNDER)
	var SliderTests = [sliderTest1, sliderMin, sliderMax, sliderCustomTicks, sliderNoCustomTicks, sliderCapMaxMin, sliderCustomTicksWithOverflow]
	#all slider tests working
	
	var prechecked = CheckToggleProperty.new("Checkbox1", "testBool", true)
	var unchecked = CheckToggleProperty.new("Checkbox2", "testBool")
	var CheckTests = [prechecked, unchecked]
	#all check tests working
	
	var dropdownIndex = DropdownProperty.new("Dropdown1", "testNum", standardizedOptionsList)
	var dropdownResult = DropdownProperty.new("Dropdown2", "testOptionsList", standardizedOptionsList)
	var emptyDropdown = DropdownProperty.new("Dropdown3", "testNum", [])
	var oneOptionOnly = DropdownProperty.new("Dropdown4", "testNum", ["One option only"])
	var intdropdown = DropdownProperty.new("Dropdown5", "testNum", [0,1,2,3,4,5])
	var DropdownTests = [dropdownIndex, dropdownResult, emptyDropdown, oneOptionOnly, intdropdown]
	#all dropdown tests working
	
	var emptyColourTest = DisplayColourProperty.new()
	var blueStaticTest = DisplayColourProperty.new("Blue", "", Color(0.1,0.2,0.8))
	var noNameColourTest = DisplayColourProperty.new("This name should not exist", "", Color.aliceblue, DisplayColourProperty.SMALL_SIZE, false, false)
	var noNameCentredTest = DisplayColourProperty.new("This name should not exist", "", Color.brown, DisplayColourProperty.NORMAL_SIZE, true, false)
	var centredTestWithName = DisplayColourProperty.new("Centred", "", Color.azure, DisplayColourProperty.FULL_SIZE, true)
	var largeSizeTest = DisplayColourProperty.new("Biggun", "", Color.darkcyan, DisplayColourProperty.LARGE_SIZE, true)
	var biggerTest = DisplayColourProperty.new("", "", Color.floralwhite, DisplayColourProperty.DOUBLE_SIZE, true)
	var biggestTest = DisplayColourProperty.new("", "", Color.black, DisplayColourProperty.GARGANTUAN_SIZE, true)
	var StaticColourTests = [emptyColourTest, blueStaticTest, noNameColourTest, noNameCentredTest, centredTestWithName, largeSizeTest, biggerTest, biggestTest]
	# all display colour tests working
	var colourCommandTest = DisplayColourProperty.new("This colour is updated:","testColour")
	#this one passed too, it's just done later
	
	var defaultColour = ColourPickerProperty.new("Colour1", "testColour")
	var specifiedColour = ColourPickerProperty.new("Colour2", "testColour", Color.lightblue)
	var withAlpha = ColourPickerProperty.new("Colour3", "testColour", ColourPickerProperty.DEFAULT_COLOUR, true)
	var ColourPickerTests = [defaultColour, specifiedColour, withAlpha]
	#
	
	#Make and fill the proplist with the properties
	var propList = []
	propList.append_array(headerTests)
	propList.append_array(lineTests)
	#propList.append_array(displayTextTests)
	#propList.append_array(TextEditTests)
	#propList.append_array(ParagraphTests)
	#propList.append_array(NumberTests)
	#propList.append_array(SliderTests)
	#propList.append_array(CheckTests)
	#propList.append_array(DropdownTests)
	propList.append_array(StaticColourTests)
	propList.append_array(ColourPickerTests)
	
	# Generate properties
	var newPropField
	var selectionMenu = get_tree().get_first_node_in_group(selectionMenuName)
	for property in propList:
		newPropField = PropertyGenerator.generate(property, obj)
		selectionMenu.add_child(newPropField)
	#man that is clean, so beautiful
	
	#additional test for if the signal is sent when a colour is changed
	var updateableColour = PropertyGenerator.generate(colourCommandTest, obj)
	selectionMenu.add_child(updateableColour)
	#updateableColour.updateColour(Color.black)
	#updateableColour.updateColour(Color.white)
	# this is working

func convertArraytoArrayofStrings():
	var test1 = "test"
	var test2 = test1
	var test3 = 8
	
	var testarray = [test1, test2, test3, Node.new(),self]
	
	# These two conversions are equivalent
	
	#Conversion 1
	var item
	var stringtype = typeof("")
	var convertedarray1 = testarray.duplicate()
	for index in convertedarray1.size():
		item = convertedarray1[index]
		if (typeof(item) != stringtype):
			if (typeof(item) < 16):
				convertedarray1[index] = String(item)
			else:
				convertedarray1[index] = item.to_string()
		print(convertedarray1[index], " | ", typeof(convertedarray1[index]))
	
	# Conversion 2
	var convertedarray2 = PoolStringArray(testarray)
	for x in convertedarray2:
		print(x, " | ", typeof(x))
