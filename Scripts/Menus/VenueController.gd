extends ItemList
class_name VenueController
## This class is used to select which Venue a layout is being made for, as well as control modifications to the venue/layout as a whole, such as zoom, pan, and resetting the layout
##
## 
##
## @experimental

#region Member Variables
#region Layout Variables
## The list of available layouts/venues that a user can select
@onready var layoutsList = get_tree().get_nodes_in_group(Venue.layoutGroupName)
## Should only be true if a layout has been selected, that is, if [member activeLayout] is not [b]null[/b]
var layoutSelected : bool = false
## The currently active layout that the user is able to add and remove objects from, which is visible to the user.
var activeLayout : Venue
#endregion

#region Zoom & Pan controllers
## Used if there is a UI element for controlling zoom
@export var zoom_controller : Range
## Used if there is a UI element for controlling vertical pan
@export var vert_pan_controller : Range
## Used if there is a UI element for controlling horizontal pan
@export var hztl_pan_controller : Range
#endregion

#var changingVenue = false # originally used because set_value_no_signal() didn't work on SpinBoxes until Godot 4.1
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.item_selected.connect(_on_venue_selection)
	addLayoutsToItemList()

## Finds everything tagged as a layout, and adds all valid ones to the list of layouts
func addLayoutsToItemList():
	var venueNum = 0
	var venue
	while (venueNum < layoutsList.size()): # we only include things that are actually venues
		venue = layoutsList[venueNum]
		if (venue is Venue):
			add_item(venue.getName())
			venue.deactivate()
			venueNum += 1
		else:
			var error_msg = "The node " + str(venue) + " is not a venue, but is inappropriately tagged in the group 'Layouts'"
			print(error_msg)
			layoutsList.remove(venueNum)
			#TODO: Add error handling here when that's ready to go
	print("Venues added")
	print(layoutsList)
#endregion

#region Venue Selection
## This is triggered by a signal from the ItemList of this object when a venue is selected.
## [br]Right now, it's essentially an alias for [member pickActiveLayout] which is split into a seperate function as a syntactic sugar so other things can more intuitively call the code
func _on_venue_selection(index): 
	pickActiveLayout(index)

## Switches to the [param layoutIndex] element within the [member layoutsList]
func pickActiveLayout(layoutIndex):
	#hide previous activeLayout, if it exists
	if (activeLayout != null):
		activeLayout.deactivate()
	
	#set the new active layout and activate it
	activeLayout = layoutsList[layoutIndex]
	activeLayout.activate()
	
	#reset zoom and pan displays to match venue's
	resetViewControllers()
	
	layoutSelected = true
#endregion

#region Zoom, Pan, and viewing options
#region GUI triggers
## This is triggered by a signal from a GUI element to reset the view of the [member activeLayout], that is, to default pan and zoom values
func _on_reset_view():
	if layoutSelected:
		activeLayout.resetView()
		resetViewControllers()

## This is triggered by a signal from a GUI element ([member zoom_controller]) to change the zoom of the [member activeLayout] by some [param percent_value] as a percentage (i.e. 100 would be full scale, 50 would be half scale, etc.)
## [br]See [method Venue.zoom] for more details.
func _on_zoom_change(percent_value):
	if (layoutLocked()):
		return
	var scalefactor = percent_value/100
	activeLayout.zoom(scalefactor)

## This is triggered by a signal from a GUI element ([member hztl_pan_controller]) to change the how the layout pans in the horizontal direction.
## [br]See [method Venue.panToPercent] for more details.
func _on_hztl_pan_change(percent_value):
	if (layoutLocked()):
		return
	activeLayout.panToPercent(percent_value,activeLayout.getPanPercent().y)

## This is triggered by a signal from a GUI element ([member vert_pan_controller]) to change the how the layout pans in the vertical direction.
## [br]See [method Venue.panToPercent] for more details.
func _on_vert_pan_change(percent_value):
	if (layoutLocked()):
		return
	activeLayout.panToPercent(activeLayout.getPanPercent().x,-percent_value)
#endregion

## Updates UI elements for zoom and pan to match the actual values from the [member activeLayout]
func resetViewControllers():
	#changingVenue = true
	#zoom and pan controllers are now optional, so we skip calling functions on them if they do not exist
	if (zoom_controller != null):
		zoom_controller.set_value_no_signal(activeLayout.getZoom() * 100)
	if ((hztl_pan_controller != null) && (vert_pan_controller != null)):
		var pan = activeLayout.getPanPercent()
		hztl_pan_controller.set_value_no_signal(pan.x)
		vert_pan_controller.set_value_no_signal(pan.y)
	#changingVenue = false
#endregion

#region Clearing the Layout
## This is triggered by a signal from a GUI element to initiate clearing all objects from a layout.
## [br]The user is given the option to confirm by a [clearConfirmPopup]. If selected, [method proceedWithClear] will be called.
func _on_clear_layout():
	# NOTE: this triggered by a signal from the clear layout button which then sends a confirmation
	if layoutSelected:
		clearConfirmPopup.new(self)

## Called when a [clearConfirmPopup] confirms with the user that all items will be cleared.
## [br]Clears all objects from the [member activeLayout].
func proceedWithClear():
	# NOTE: this is triggered by a confirm response after _on_clear_layout
	activeLayout.clearObjects()

## An internal class that simply checks if the user wants to clear all objects from the [member activeLayout].
## [br]Essentially just a [ConfirmationDialog], but automatically deletes itself from memory once closed in any way.
class clearConfirmPopup extends ConfirmationDialog:
	#NOTE: this internal class just makes sure that it is deleted from memory after it's finished being used
	var venueSelector : VenueController
	func _init(attachingNode : VenueController):
		# Properties
		self.window_title = "Are you sure?"
		self.dialog_text = "Clearing the layout will remove ALL objects from the venue layout, and cannot be undone. Are you sure you want to clear the layout?"
		self.exclusive = true
		# Add to tree under whatever node it is supposed to attach to, temporarily
		venueSelector = attachingNode
		venueSelector.add_child(self)
	func _ready(): # pops up when created
		self.popup_centered()
		get_cancel_button().pressed.connect(self._on_decided)
		self.confirmed.connect(self._on_confirmed)
	func _on_confirmed():
		self.venueSelector.proceedWithClear() #if confirmed, will clear everything, otherwise does nothing
		self._on_decided()
	func _on_decided(): # deletes itself once finished
		self.queue_free()
#endregion

#region Getters and Setters
## Returns the [member activeLayout]
func getActiveLayout() -> Venue:
	return activeLayout

## Returns whether the value of [member layoutSelected]
func hasLayoutSelected() -> bool:
	return layoutSelected #&& (activeLayout != null)

## This was used in the old tests when changingVenue was used, but it looks like that's no longer needed thanks to Godot 4.1 fixing spinboxes and setting values without sending signals
## [br]Mostly an alias for [method hasLayoutSelected], but adds on a check to see if [member activeLayout] actually exists, rather than just relying on [member layoutSelected]
func layoutLocked() -> bool:
	return hasLayoutSelected() && (activeLayout != null) #right now this can just be an alias for clarity
#	#return (activeLayout == null) || changingVenue
#	# if there is not an active layout selected, don't do anything with the layout that doesn't exist
#endregion
