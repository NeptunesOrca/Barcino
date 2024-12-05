extends ParentDraggableObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ParentDraggableObject_gui_input(event):
	._on_ParentDraggableObject_gui_input(event)
	print("A Child did this")
	
