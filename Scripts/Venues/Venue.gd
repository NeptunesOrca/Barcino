@tool
extends CanvasLayer
class_name Venue
## Controls images of the various UABG Venues, as well as what objects are included in the layout for that venue.
##
##

#region Member Variables
#region Venue Properties
## The group that applies to all layouts
const layoutGroupName = "Layouts"
## The name of the Venue (e.g. Diwan, Welcome Centre, etc.)
@export var venueName : String:
	get:
		return venueName
	set(newName):
		venueName = newName
#endregion

#region Venue Image
## The node that displays the the [member venueImage] in the background for the layout.
## [br]Short for [b]Image Text[/b]ure [b]Rect[/b]angle.
@onready var imageTextRect = TextureRect.new()
## The name for the [member imageTextRect] as used in the code
const imageDisplayName = "VenueImageDisplay"
## The image displayed as the venue background
@export var venueImage : Texture:
	get:
		return venueImage
	set(newtexture):
		venueImage = newtexture
		updateImage()

## The background canvaslayer, which the [member imageTextRect] is on.
@onready var background = CanvasLayer.new()
## The name for the [member background] as used in the code
const backgroundName = "Background"
#endregion

#region Venue View Variables
#region Zoom
## The default zoom value for the venue and layout. Given as a factor, not a percentage. Defaults to 1 (equivalent to 100%), but can be set for each venue.
@export var defaultZoom : float = 1.0:
	get:
		return defaultZoom
	set(value):
		defaultZoom = value
		venueZoom = defaultZoom
		if (background != null):
			updateZoom()

## The zoom factor for the venue and layout. Given as a factor not a percentage. Defaults to the [member defaultZoom].
var venueZoom : float = defaultZoom
#endregion

#region Pan
## The default value for how much the venue should be panned, measured in pixels compared to the reference frame of the [member venueImage].
## [br]Defaults to (0,0).
@export var defaultPan = Vector2(0,0):
	get:
		return defaultPan
	set(value):
		defaultPan = value
		venuePan = defaultPan
		if (background != null):
			updatePan()

## The amount the venue is panned in the horizontal and vertical directions measured in pixels compared ot the reference frame of the [member venueImage]
## Defaults to [member defaultPan].
var venuePan : Vector2 = defaultPan
#endregion
#endregion
#endregion

#region Startup
## Called when the node enters the scene tree for the first time.
## [br] - Sets up the [member background] and [member imageTextRect] with the correct name and structure
## [br] - Adds itself to the [member layoutGroupName] group so it can be found by the [VenueController]
## [br] - Connects the visiblity_changed signal to [method _on_Venue_visibility_changed] so that when the visibility of the [Venue] changes, it is properly reflected by the [member background]
## [br] - Ensures the venue is deactivated by default so that [VenueController] will show only the selected Venue
func _ready() -> void:
	#Add this to the correct group
	add_to_group(Venue.layoutGroupName)
	
	#Setup the background canvas and add the image for the venue to it
	#In the structure of:
	# Venue
	#	↳ Background (a CanvasLayer)
	#		↳ imageTextRect
	background.name = backgroundName
	background.layer = ProjectConstants.mainGUILayer - 1 # The background must appear behind everything else
	imageTextRect.name = imageDisplayName
	self.add_child(background)
	background.add_child(imageTextRect)
	
	#Connect any visibility changes for the background to the 
	#updateImage(venueImage) #this should be handled by the setter for the image
	self.visibility_changed.connect(_on_Venue_visibility_changed)
	deactivate()
#endregion

#region Object Related
## Clears all the user-added objects from the layout, giving a clean slate to start over.
func clearObjects():
	var children = self.get_children()
	
	for obj in children:
		if obj == background :
			# Do not delete the background
			continue
		obj.queue_free()
#endregion

#region View Changing
#region Image
func updateImage():
	if (imageTextRect != null):
		imageTextRect.texture = venueImage
	else:
		var error_msg = "The imageTextRect (the Texture Rectangle for the venue image) of  " + str(self) + " is null "
		#TODO: Error handling
		#ErrorHandler.newError(self, error_msg)
#endregion

#region Visibility
## Hides and deactivates the layout. Visibility of the [member imageTextRect] is controlled via [method _on_Venue_visibility_changed]
func deactivate():
	set_visible(false)

## Shows and activates the layout. Visibility of the [member imageTextRect] is controlled via [method _on_Venue_visibility_changed]
func activate():
	set_visible(true)

## Automatically changes the visibility of the background and with it the [member imageTextRect] to match the visibility of the layout as a whole.
## [br]Triggered by the [signal visibility_changed] signal from the [Venue]
func _on_Venue_visibility_changed():
	background.set_visible(is_visible())
#endregion

#region Reset
## Resets the view of the layout to match the defaults in [member defaultZoom] and [member defaultPan]
func resetView():
	venueZoom = defaultZoom
	venuePan = defaultPan
	updatePan()
	updateZoom()
#endregion

#region Zoom
## Returns the current value of [member veneuZoom]
func getZoom() -> float:
	return venueZoom

## Makes the changes to the [Venue] and [member imageTextRect] for the venue background and layout to match the value in [member venueZoom]
func updateZoom():
	self.set_scale(Vector2(venueZoom,venueZoom))
	background.set_scale(Vector2(venueZoom, venueZoom))

## Changes the zoom of the [Venue] to the value [param scaleFactor] as a factor, then calls [method updateZoom]
func zoom(scaleFactor : float):
	venueZoom = scaleFactor
	updateZoom()

## Syntactic sugar for [method zoom] that takes the value [param percent] as a percentage instead of as a factor.
func zoomByPercent(percent):
	zoom(percent/100.0)
#endregion

#region Pan
## Returns the current value of [member venuePan]
func getPan() -> Vector2:
	return venuePan

## Returns the current value of [member venuePan] as a relative percentage of the [member venueImage] size
func getPanPercent() -> Vector2:
	return Vector2((venuePan.x / venueImage.get_width())*100, (venuePan.y / venueImage.get_height())*100)

## Makes the changes to the [Venue] and [member imageTextRect] for the venue background and layout to match the value in [member venuePan]
func updatePan():
	self.set_offset(venuePan)
	background.set_offset(venuePan)

## Increments the value of [member venuePan] and adjusts the [Venue]'s pan value by [param hztl_val] pixels in the horizontal direction and [param vert_val] pixels in the vertical direction
func panBy(hztl_val, vert_val):
	venuePan += Vector2(hztl_val, vert_val)
	updatePan()

## Increments the [Venue]'s pan value, similar to [method panBy], but changing the image by a relative proportion to the size of the [member venueImage].
## [br][param lr_percent] is the percentage of the [member venueImage]'s width to shift the layout by in the horizontal direction
## [br][param ud_percent] is the percentage of the [member venueImage]'s height to shift the layout by in the vertical direction
func panByPercent(lr_percent := 0, ud_percent := 0):
	var lr_relative = (lr_percent/100.0)*venueImage.get_width()
	var ud_relative = (ud_percent/100.0)*venueImage.get_height()
	panBy(lr_relative, ud_relative)

## Sets the value of [member venuePan] and sets the [Venue]'s pan value to [param hztl_val] pixels in the horizontal direction and [param vert_val] pixels in the vertical direction
func panTo(hztlPan := venuePan.x, vertPan := venuePan.y):
	venuePan = Vector2(hztlPan, vertPan)
	updatePan()

## Set the [Venue]'s pan value, similar to [method panTo], but changing the image by a relative proportion to the size of the [member venueImage].
## [br][param lr_percent] is the percentage of the [member venueImage]'s width to set the layout to in the horizontal direction
## [br][param ud_percent] is the percentage of the [member venueImage]'s height to set the layout to in the vertical direction
func panToPercent(lr_percent := getPanPercent().x, ud_percent := getPanPercent().y):
	var lrAbsolute = (lr_percent/100.0)*venueImage.get_width()
	var udAbsolute = (ud_percent/100.0)*venueImage.get_height()
	panTo(lrAbsolute, udAbsolute)
#endregion
#endregion
