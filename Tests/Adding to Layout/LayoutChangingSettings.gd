extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var layout

# Called when the node enters the scene tree for the first time.
func _ready():
	layout = get_tree().get_first_node_in_group("ActiveLayout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_x_Scale_value_changed(value):
	var newScale = layout.get_scale()
	newScale.x = value
	layout.set_scale(newScale)
	
func _on_y_Scale_value_changed(value):
	var newScale = layout.get_scale()
	newScale.y = value
	layout.set_scale(newScale)

func _on_x_Offset_value_changed(value):
	var newOffset = layout.get_offset()
	newOffset.x = value
	layout.set_offset(newOffset)

func _on_y_Offset_value_changed(value):
	var newOffset = layout.get_offset()
	newOffset.y = value
	layout.set_offset(newOffset)
