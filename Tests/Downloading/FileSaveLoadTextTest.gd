extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btsave_pressed() -> void:
	# Save the TextEdit node in a variable as it may be used a few times
	var txtedit: TextEdit = $vbox/text
	
	if (txtedit.text.empty()):
		# The text is empty, bail because there is no data
		return
	
	# Check the platform
	if (OS.get_name() == "HTML5"):
		# Indeed in HTML export. Check if JavaScript is available
		if (OS.has_feature("JavaScript")):
			#right now, all we can do is download text from the textedit as a .txt
			JavaScript.download_buffer(txtedit.text.to_utf8(), "default_output.txt", "text/plain")
			#JavaScript.create_callback()
		
		else:
			# Running in HTML but without JavaScript available.
			var error_msg = "Browser cannot use JavaScript, saving is not possible!"
			ErrorHandler.newError(self, error_msg)
	
	else:
		pass
		# Non HTML export. Use traditional code, that is, display the FileDialog
