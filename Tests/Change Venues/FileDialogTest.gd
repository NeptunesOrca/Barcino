extends FileDialog

var minsize = Vector2(750,500)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mode_overrides_title = true
	self.popup_exclusive = true
	self.mode = FileDialog.MODE_SAVE_FILE
	self.access = FileDialog.ACCESS_FILESYSTEM
	get_cancel().connect("pressed",self,"_on_cancelled")
	connect("dir_selected",self,"_on_dir_selected")
	connect("file_selected",self,"_on_file_selected")
	connect("confirmed",self,"_on_confirmed")
	var screensize = get_viewport_rect().size
	var dialogsize = screensize/2
	if (screensize.x / 2 < minsize.x):
		dialogsize.x = minsize.x
	if (screensize.y / 2 < minsize.y):
		dialogsize.y = minsize.y
	self.set_size(dialogsize)
	self.popup_centered()

func _on_cancelled():
	print("cancel")

func _on_dir_selected():
	print("dir selected")
	
func _on_file_selected(_file):
	print("file selected")

func _on_confirmed():
	print("confirmed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
