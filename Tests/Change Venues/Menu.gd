extends TabContainer
class_name Menu

enum TabNumber {VENUES_TAB, OBJECTS_TAB}
var availableFileTypes = [".png"]

var canvasLayer : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#find canvas layer
	canvasLayer = getCanvasLayer(10)

func getCanvasLayer(maxIterations: int):
	var returnCanvasLayer
	var obj = self
	var iterations = 0
	var errMsg
	while ((returnCanvasLayer == null) && (iterations <= maxIterations)):
		obj = self.get_parent()
		if (obj == null):
			#No parent found
			errMsg = "There does not exist a CanvasLayer that is a ancestor to this menu within the tree, and there are no more ancestors to check."
			ErrorHandler.newError(self, errMsg)
			break
		if (obj.is_class("CanvasLayer")):
			#The canvas layer for this menu has been found, hooray!
			returnCanvasLayer = obj
			return returnCanvasLayer
		#otherwise, keep looking up the tree
		iterations += 1
	
	errMsg = "A CanvasLayer parent could not be found for the menu within " + str(maxIterations) + ", please specify a larger number of iterations, check the node tree, and report this message to support."
	ErrorHandler.newError(self, errMsg)
	return returnCanvasLayer

func isInside(position: Vector2) -> bool:
	return get_rect().has_point(position)

func switchMenuTab(tabnum : int):
	if (tabnum >= 0 && tabnum < TabNumber.size()): # checks if a valid tab number has been passed in
		set_current_tab(tabnum)
		return
	else: 
		var error_msg = "The tab  index " + str(tabnum) + " does not correspond to a tab within the Menu"
		ErrorHandler.newError(self, error_msg)

#class printSave extends FileDialog:
#	var menu : Menu
#	func _init(attachingNode : Menu):
#		# Properties
#		self.popup_exclusive = true
#		# Add to tree under whatever node it is supposed to attach to, temporarily
#		menu = attachingNode
#		menu.add_child(self)
#	func _ready(): # pops up when created
#		self.popup_centered()
#		get_cancel().connect("pressed",self,"_on_cancelled")
#		self.connect("confirmed",self,"_on_confirmed")
#	func _on_confirmed():
#		#do something
#		pass
#	func _on_cancelled():
#		self.finish()
#	func finish(): # deletes itself once finished
#		self.queue_free()

func startPrintProcess():
	var _saveDialog = FileAccessor.new(self, "printLayout")
	
	# get filename and directory location to save to 

# Just a quick inner class for the flash warning that will delete itself once finished
class FlashWarningDialog extends AcceptDialog:
	signal flash_warn_done
	func _init(attachingNode : Menu):
		self.dialog_text = "This program may flash briefly while we save your layout."
		attachingNode.add_child(self)
	func _ready():
		self.connect("confirmed",self,"_on_decided")
		self.connect("hide",self,"_on_decided")
		self.connect("modal_closed",self,"_on_decided")
		self.popup_centered()
	func _on_decided():
		emit_signal("flash_warn_done") #tells whatever is listening (i.e. the menu) that it's finished
		self.queue_free()

func printLayout(saveResults : FileDetailsReturn):
	#Error Check
	if (not saveResults.isValid):
		var error_msg = "A valid location to save was not found. Please try saving to a different location or contact support."
		ErrorHandler.newError(self, error_msg)
		return
	
	#warn user about flashing
	var flashwarning = FlashWarningDialog.new(self)
	yield(flashwarning,"flash_warn_done")
	
	#turn off menu visibility
	canvasLayer.hide()
	#wait for a frame to get all the UIs out of the way
	yield(get_tree(), "idle_frame") # for some reason, we need this twice.
	yield(get_tree(), "idle_frame") # I loooooooove GODOT and all its quirks especially this one <3
	#generate image of layout
	var layoutImage = get_viewport().get_texture().get_data()
	#flip the image because for some reason, GODOT will save the image upside down
	layoutImage.flip_y() #being sick at work leads to sarcastic comments. I love GODOT all the time in every way.
	#turn menu visibility back on
	canvasLayer.show()
	#print additional info
	#somehow squish together with layout image
	#save as one file to selected location
	var filetype = ".png"
	var locationString = saveResults.directory_location + "/" + saveResults.filename_string
	if (not saveResults.filename_string.ends_with(filetype)):
		locationString += filetype
	print("Attempting to save to: ", locationString)
	layoutImage.save_png(locationString)
