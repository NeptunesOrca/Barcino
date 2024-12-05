extends Panel


# Declare member variables here. Examples:
export  (PackedScene) var Obj


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ObjectCreator_gui_input(event):
	if event is InputEventScreenDrag:
		pass
		#newobj.setPosition(event.position)
		#newobj.setPosition(Vector2(100,100))
		#newobj.setDragging(true)
