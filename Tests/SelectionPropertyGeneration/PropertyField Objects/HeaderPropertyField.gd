extends PropertyField
class_name HeaderPropertyField

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const headerStyleLocation ="res://Tests/SelectionPropertyGeneration/HeaderTheme.tres"

func _init(obj : DraggableObject, property : HeaderProperty).(obj, property):
	# Change text to header value
	var headerObj = self.getNameObject()
	headerObj.text = property.header
	# Change theme to the header theme
	var headerStyle = load(headerStyleLocation)
	headerObj.theme = headerStyle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
