extends AcceptDialog
class_name CustomError
## Class for custom error popups to indicate that something has gone wrong with the program.
## [br][b]Not[/b] for use for cases where the user does something incorrectly (e.g. invalid input), this class is [i]exclusively[/i] for situations where the programmer has made a mistake.

## The list of defined errors.
## [br] Follows the general categorization as below:
## [br] - 0000 : General Errors
## [br] - 1000 : Menu and UI Errors
## [br] - 2000 : [Venue]/Layout Errors
## [br] - 3000 : [DraggableObject] Errrors
## [br] - 4000 :
enum ErrorTypes {
	TEST_ERROR_NO_NAME = -102,		## Test Error, used for testing errors that don't have names
	TEST_ERROR = -100, 				## Test Error, used for testing that errors are working correctly
	MISSING_ERROR_NUMBER = -2, 		## Indicates that while a error number has been passed, [member ErrorNames] does not have an appropriate name for it
	UNDEFINED_ERROR_NUMBER = -1,	## A default error number for any undefined error. Set to -1.
	MISSING_PARENT_NODE = 89, 		## Used for when a parent node is expected, but not found
	MISSING_CANVAS_LAYER_PARENT = 1089, ## Used for when a [Menu] cannot find [CanvasLayer] as an ancestor
	BAD_VENUE_TAG = 2000, ## Use for when a [Node] has been inappropriately labelled as a [Venue]
	VENUE_WITHOUT_IMAGE = 2404, ## Used for when a [Venue] does not have an image
}

## The appropriate name for each value of [enum ErrorTypes]
## Explicitly does not include TEST_ERROR_NO_NAME as a key, for the purposes of testing the missing number functionality
const ErrorNames  = {
	ErrorTypes.TEST_ERROR: "TEST ERROR",
	ErrorTypes.MISSING_ERROR_NUMBER: "UNNAMED ERROR #", ## Should have the actual error number apended to the end
	ErrorTypes.UNDEFINED_ERROR_NUMBER: "UNDEFINED ERROR",
	ErrorTypes.MISSING_PARENT_NODE: "MISSING PARENT NODE",
	ErrorTypes.MISSING_CANVAS_LAYER_PARENT: "MISSING [CanvasLayer] ANCESTOR",
	ErrorTypes.BAD_VENUE_TAG: "IMPROPER USE OF [Venue.layoutGroupName] TAG (" + Venue.layoutGroupName + ")",
	ErrorTypes.VENUE_WITHOUT_IMAGE: "MISSING VENUE IMAGE",
}

## Constructor for the [Error] class.
## [br] Requires [param error_msg]. This string is passed directly as the [member AcceptDialog.dialog_text] of the [Error], and should be generated with all relevant information by calling code.
## [br] [param error_num] defaults to [member undefinedErrorNumber] (-1). If specified as a key within [member ErrorTypes], will populate the error's [member AcceptDialog.title] with the appropriate value.
## [br] [param pushToConsole] defaults to [code]true[/code]. Set to [code]false[/code] if you do not want to push the error message to console (which may stop execution)
func _init(error_msg: String, error_num := ErrorTypes.UNDEFINED_ERROR_NUMBER, pushToConsole := true):
	#Require the user to click OK to close
	self.exclusive = true
	
	# Generate the error title
	var error_title = "ERROR " + str(error_num) + ": "
	var error_label
	if (ErrorTypes.has(error_num)):
		# Check for missing error numbers, in case an error number has been listed in ErrorTypes, but a name has not been made for it in ErrorNames
		if (ErrorNames.has(error_num)):
			error_label = ErrorNames.get(error_num)
		else:
			error_label = ErrorNames.get(ErrorTypes.MISSING_ERROR_NUMBER) + str(error_num)
		
		# For the default undefined error, overwrite the title
		if (error_num == ErrorTypes.UNDEFINED_ERROR_NUMBER):
			error_title = "ERROR: " #overwrites the title because "ERROR -1: " for the start of the title would just be silly
	else:
		# If some unknown number, use the undefined error label
		error_label = ErrorNames.get(ErrorTypes.UNDEFINED_ERROR_NUMBER)
	# The error title should finaly take the general form "ERROR #: ERROR NAME"
	error_title += error_label
	
	#Populate error window with correct text
	self.dialog_text = error_msg + "\nPlease contact support and report this error."
	self.title = error_title
	
	#Push the error to the console, unless told to do not push
	if (pushToConsole):
		push_error(error_title + " | " + error_msg)
	
	#Ensure connections made
	self.confirmed.connect(_on_confirm)

## Called when the node enters the scene tree for the first time.
## Immediately pops up the error message.
func _ready() -> void:
	#Popup
	self.popup_centered()

## Handles when the user confirms and [signal confirmed] is sent.
## Deletes the node to conserve memory
func _on_confirm():
	queue_free()
