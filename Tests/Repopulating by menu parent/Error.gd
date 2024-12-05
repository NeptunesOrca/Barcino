extends AcceptDialog
class_name CustomError



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init(error_msg: String, error_num := -1):
	# Require the user to click OK to close
	self.popup_exclusive = true
	
	# Generate the error title
	var error_title
	var error_label
	if (error_num < 0):
		error_label = "UNRECOGNIZED ERROR"
	else:
		error_label = str(error_num)
	error_title = "ERROR: " + error_label
	
	#Populate the error window with the correct text
	self.dialog_text = error_msg
	self.window_title = error_title
	
	# Push the error to the console
	push_error(error_title + " | " + error_msg)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Popup error
	self.popup_centered()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AcceptDialog_confirmed():
	# Once confirmed, delete self
	queue_free()
