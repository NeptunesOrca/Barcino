extends ItemList
class_name VenueSelector

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Layouts
var layoutGroupName = "Layout"
onready var layoutsList = get_tree().get_nodes_in_group(layoutGroupName)
var layoutSelected = false
var activeLayout setget pickActiveLayout, getActiveLayout

# Zoom & Pan contollers
export(NodePath) var zoom_control_path
export(NodePath) var updown_pan_control_path
export(NodePath) var leftright_pan_control_path
onready var zoom_control = get_node(zoom_control_path)
onready var updown_pan_control = get_node(updown_pan_control_path)
onready var leftright_pan_control = get_node(leftright_pan_control_path)

#
var changingVenue = false #used during resetViewControllers() to prevent zoom and pan controls from changing anything while chaning between venues, because set_value_no_signal() doesn't actually work on SpinBoxes, which is fixed in Godot 4.1

# Called when the node enters the scene tree for the first time.
func _ready():
	addLayoutsToItemList()
	
# Makes a list of all venues that can be selected and puts it in the item list for the user to select
func addLayoutsToItemList():
	var venueNum = 0
	var venue
	while (venueNum < layoutsList.size()): # we only include things that are actually venues
		venue = layoutsList[venueNum]
		if (venue is Venue):
			add_item(venue.getName())
			venue.hide()
			venueNum += 1
		else:
			var error_msg = "The node " + str(venue) + " is not a venue, but is inappropriately tagged in the group 'Layouts'"
			layoutsList.remove(venueNum)
			ErrorHandler.newError(self, error_msg)

func layoutLocked() -> bool:
	return changingVenue || (activeLayout == null)

func _on_VenueSelector_item_selected(index):
	pickActiveLayout(index)

func _on_Zoom_value_changed(percent_value):
	if (layoutLocked()):
		return
	var scalefactor = percent_value/100
	activeLayout.zoom(scalefactor)
	
func _on_HZTL_pan_value_changed(percent_value):
	if (layoutLocked()):
		return
	activeLayout.panToPercent(percent_value,activeLayout.getPanPercent().y)
		
func _on_VERT_pan_value_changed(percent_value):
	if (layoutLocked()):
		return
	activeLayout.panToPercent(activeLayout.getPanPercent().x,-percent_value)

func pickActiveLayout(layoutIndex):	
	#hide previous activeLayout, if it exists
	if (activeLayout != null):
		activeLayout.hide()
	
	#set the new active layout and activate it
	activeLayout = layoutsList[layoutIndex]
	activeLayout.activate()
	
	#reset zoom and pan displays to match venue's
	resetViewControllers()
	
	layoutSelected = true

func getActiveLayout() -> Venue:
	return activeLayout

func hasLayoutSelected() -> bool:
	return layoutSelected

func _on_reset_view():
	if layoutSelected:
		activeLayout.resetView()
		resetViewControllers()

class clearConfirmPopup extends ConfirmationDialog:
	var venueSelector : VenueSelector
	func _init(attachingNode : VenueSelector):
		# Properties
		self.window_title = "Are you sure?"
		self.dialog_text = "Clearing the layout will remove ALL objects from the venue layout, and cannot be undone. Are you sure you want to clear the layout?"
		self.popup_exclusive = true
		# Add to tree under whatever node it is supposed to attach to, temporarily
		venueSelector = attachingNode
		venueSelector.add_child(self)
	func _ready(): # pops up when created
		self.popup_centered()
		get_cancel().connect("pressed",self,"_on_decided")
		self.connect("confirmed",self,"_on_confirmed")
	func _on_confirmed():
		self.venueSelector.proceedWithClear() #if confirmed, will clear everything, otherwise does nothing
		self._on_decided()
	func _on_decided(): # deletes itself once finished
		self.queue_free()

func _on_clear_layout():
	if layoutSelected:
		clearConfirmPopup.new(self)
	
func proceedWithClear():
	activeLayout.clearObjects()
	
func resetViewControllers():
	changingVenue = true
	zoom_control.set_value(activeLayout.getZoom() * 100)
	var pan = activeLayout.getPanPercent()
	leftright_pan_control.set_value(pan.x)
	updown_pan_control.set_value(pan.y)
	changingVenue = false
