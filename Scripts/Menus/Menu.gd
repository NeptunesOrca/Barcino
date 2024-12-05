extends TabContainer
class_name Menu
## A parent class for different types of menus
##
## Includes some basic functions needed by all menus, including finding the menu canvas, and checking if a point is inside the boundary of the menu

## The [CanvasLayer] for all menu items, which should be the same for all menu objects. It should also be an ancestor of all menu items.
var menuCanvas : CanvasLayer

#region Startup
## Called when the node enters the scene tree for the first time. Finds the [member menuCanvas] so that it doesn't need to be found again
func _ready() -> void:
	menuCanvas = findMenuCanvasLayer(10) #10 iterations should be more than enough to find the menu canvaslayer
	# especially since it should be the parent of the control menu

## Returns the ancestor [CanvasLayer] of the [Menu], which is then used as the [member menuCanvas].
## [br]Takes [param maxIterations] as a parameter, because an appropriate ancestor should be found quite quickly and if it is not, something has gone wrong.
## [method _ready()] uses a value of 10 for [param maxIterations], which should already be overkill.
func findMenuCanvasLayer(maxIterations: int) -> CanvasLayer:
	#setup
	var returnCanvasLayer
	var obj = self
	var iterations = 0
	var errMsg
	
	# we manually search up the tree examining each object's parent until we find something of the correct type
	# this isn't particularly efficient, but it's going to work, and we don't need to do it very often
	while ((returnCanvasLayer == null) && (iterations <= maxIterations)):
		obj = self.get_parent()
		if (obj == null):
			#no parent found
			#TODO: do error message once we have error handling
			break
		if (obj.is_class("CanvasLayer")):
			# the menu canvaslayer has been found
			returnCanvasLayer = obj
			return returnCanvasLayer
		#otherwise, keep looking up the tree to find the menu canvas
		iterations +=1
	
	#we reach the maximum iterations, something's gone wrong
	#TODO: do error message once we have error handling
	
	return null
#endregion

#region Getters and Setters
## Returns the value of [member menuCanvas] in case some other object needs to reference that
func getMenuCanvasLayer() -> CanvasLayer:
	return menuCanvas
#endregion

#region Point Tests
## Tests if a particular point [param mousespacePosition] within mouse/display space (i.e.  using the coordinates relative to the user's screen/window/display/mouse) is within the area of the [Menu]
func isInside(mousespacePosition : Vector2) -> bool:
	return self.get_rect().has_point(mousespacePosition)
#endregion
