tool
extends CanvasLayer
class_name Venue

# Background Texture
export(Texture) var venueImage setget updateImage, getImage
onready var imageTextRect = $Background/VenueImage

# Reference Rect colour
export(Color) var referenceRectColour setget updateRefRectColour, getRefRectColour
onready var refRect = $Background/ReferenceRect

# Name
export(String) var venueName setget changeName, getName

#
var venueZoom = 1 setget zoom, getZoom
var venuePan = Vector2(0,0) setget panBy, getPan

# Called when the node enters the scene tree for the first time.
func _ready():
	updateImage(venueImage)
	hide()

func getImage() -> Texture:
	return venueImage

func updateImage(newtexture : Texture):
	imageTextRect = $Background/VenueImage
	if (imageTextRect != null):
		venueImage = newtexture
		imageTextRect.texture = venueImage
	else:
		var error_msg = "The imageTextRect (the Texture Rectangle for the venue image) of  " + str(self) + " is null "
		ErrorHandler.newError(self, error_msg)

func updateRefRectColour(newColour : Color):
	refRect = $Background/ReferenceRect
	if (refRect != null):
		referenceRectColour = newColour
		refRect.border_color = newColour

func getRefRectColour() -> Color:
	return referenceRectColour
	
func getName() -> String:
	return venueName
	
func changeName(newName : String):
	venueName = newName
	
func hide():
	set_visible(false)
	
func activate():
	set_visible(true)

func _on_Venue_visibility_changed():
	$Background.set_visible(is_visible())

func zoom(scaleFactor):
	venueZoom = scaleFactor
	self.set_scale(Vector2(venueZoom,venueZoom))
	$Background.set_scale(Vector2(venueZoom, venueZoom))

func panByPercent(hztlPercent := 0,vertPercent := 0):
	var lrRelative = (hztlPercent/100.0)*venueImage.get_width()
	var udRelative = (vertPercent/100.0)*venueImage.get_height()
	panBy(lrRelative, udRelative)
	
func panBy(leftrightPan=0, updownPan=0):
	venuePan += Vector2(leftrightPan, updownPan)
	updatePan()

func panToPercent(hztlPercent := getPanPercent().x,vertPercent := getPanPercent().y):
	var lrAbsolute = (hztlPercent/100)*venueImage.get_width()
	var udAbsolute = (vertPercent/100)*venueImage.get_height()
	panTo(lrAbsolute, udAbsolute)

func panTo(leftrightPan=venuePan.x, updownPan=venuePan.y):
	venuePan = Vector2(leftrightPan,updownPan)
	updatePan()

func updatePan():
	self.set_offset(venuePan)
	$Background.set_offset(venuePan)

func getZoom() -> int:
	return venueZoom
	
func getPan() -> Vector2:
	return venuePan

func getPanPercent() -> Vector2:
	return Vector2((venuePan.x / venueImage.get_width())*100,(venuePan.y / venueImage.get_height())*100)

func resetView():
	venueZoom = 1
	venuePan = Vector2(0,0)
	updatePan()
	zoom(venueZoom)

func clearObjects():
	var children = self.get_children()
	
	for obj in children:
		if obj == $Background:
			continue
		obj.queue_free()
