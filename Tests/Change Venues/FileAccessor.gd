extends FileDialog
class_name FileAccessor

signal file_location_decided(result)

var minsize = Vector2(750,500)
var usesHTML = false
var connectedNode : Node
var fcnName : String
var returnObj : FileDetailsReturn

func _init(attachingNode : Node, onResultCall_fcnName : String, mode := FileDialog.MODE_SAVE_FILE):
	# Add to tree under whatever node it is supposed to attach to, temporarily
	connectedNode = attachingNode
	connectedNode.add_child(self)
	
	# Save the name of the function that should be called on the connectingNode when finished
	# i.e. connectingNode.fcnName() will be called when finished
	fcnName = onResultCall_fcnName
	
	#Setup return object
	returnObj = FileDetailsReturn.new()
	returnObj.mode = mode
	
	#Determine how we're going to get the directory and filename information
	# HTML Mode
	if (OS.get_name() == "HTML5"):
		usesHTML = true
		# Indeed in HTML export. Check if JavaScript is available
		if (OS.has_feature("JavaScript")):
			pass
			#Somehow use Javascript to open up a dialog box to access system files
			#JavaScript.create_callback()
		else:
			# Running in HTML5 but without JavaScript available.
			var error_msg = "Browser cannot use JavaScript, saving is not possible!"
			ErrorHandler.newError(attachingNode, error_msg)
			returnObj.isValid = false
			self.finish()
	
	# Native Mode
	else:
		usesHTML = false
		self.mode_overrides_title = true
		self.popup_exclusive = true
		self.mode = mode
		self.access = FileDialog.ACCESS_FILESYSTEM

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("file_location_decided", connectedNode, fcnName)
	
	if (usesHTML):
		current_file = "Screenshot_" + str(OS.get_time())
		current_dir = "testdirectory"
	else:
		get_cancel().connect("pressed",self,"_on_cancelled")
		connect("dir_selected",self,"_on_confirmed")
		connect("file_selected",self,"_on_confirmed")
		connect("confirmed",self,"_on_confirmed")
		var screensize = get_viewport_rect().size
		var dialogsize = screensize/2
		if (screensize.x / 2 < minsize.x):
			dialogsize.x = minsize.x
		if (screensize.y / 2 < minsize.y):
			dialogsize.y = minsize.y
		self.set_size(dialogsize)
		#self.set_current_path("C:/") # I would like to find a way to set this to a more normal place, but hey
		self.popup_centered()

func _on_confirmed(_file):
	print("confirmed")
	returnObj.isValid = true
	returnObj.filename_string = current_file
	returnObj.directory_location = current_dir
	self.finish()
func _on_cancelled():
	print("cancelled")
	returnObj.isValid = false
	self.finish()
func finish():
	print("finished")
	# send the returnobject to wherever it's supposed to go
	emit_signal("file_location_decided", returnObj)
	connectedNode.printLayout(returnObj)
	# deletes itself once finished
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
