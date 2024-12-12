extends AcceptDialog
class_name CustomError
## Error Popups

## A default error number for any undefined error. Set to -1.
const undefinedErrorNumber = -1
## The list of defined errors, stored in the form errorNumber : ErrorName
## Must not contain [member undefinedErrorNumber] (-1) as a key.
const DefinedErrors  = {
	0: "Test Error", ## Test Error, used for testing that errors are working correctly
}

## Constructor for the [CustomError] class.
## [br] Requires [param error_msg]. This string is passed directly as the [member AcceptDialog.dialog_text] of the [CustomError], and should be generated with all relevant information by calling code.
## [br] [param error_num] defaults to [member undefinedErrorNumber] (-1). If specified as a key within [member DefinedErrors], will populate the error's [member AcceptDialog.title] with the appropriate value.
## [br] [param pushToConsole] defaults to [code]true[/code]. Set to [code]false[/code] if you do not want to push the error message to console (which may stop execution)
func _init(error_msg: String, error_num := undefinedErrorNumber, pushToConsole := true):
	#Require the user to click OK to close
	self.excluse = true
	
	# Generate the error title
	var error_title = "ERROR " + str(error_num) + ": "
	var error_label
	if (DefinedErrors.has(error_num)):
		error_label = DefinedErrors.get(error_num)
	else:
		error_label = "UNDEFINED ERROR"
		if (error_num < 0):
			error_title = "ERROR: " #overwrites the title because "ERROR -1: " for the start of the title would just be silly
	error_title += error_label
	
	#Populate error window with correct text
	self.dialog_text = error_msg
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
	print("Deleting error")
	queue_free()
