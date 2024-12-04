extends TabContainer
class_name Menu

var menuCanvas : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuCanvas = findMenuCanvasLayer(10) #10 iterations should be more than enough to find the menu canvaslayer
	# especially since it should be the parent of the control menu

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

func getMenuCanvasLayer() -> CanvasLayer:
	return menuCanvas

func isInside(mousespacePosition : Vector2) -> bool:
	return self.get_rect().has_point(mousespacePosition)
