extends HBoxContainer
class_name PropertyField

const minwidth = 182
const minheight = 0

var definition : Property
var associatedObject : DraggableObject
var propertyName : Label

#const defaultStyleLocation ="res://Tests/SelectionPropertyGeneration/HeaderTheme.tres"
#var defaultStyle = load(headerStyleLocation)

func _init(obj : DraggableObject, prop : Property):
	#Note that Godot does superclass initialization before subclass initialization
	self.rect_min_size = Vector2(minwidth, minheight)

	definition = prop
	associatedObject = obj
	
	# Generate name label
	var text = definition.propName + ":"
	propertyName = Label.new()
	propertyName.text = text
	self.add_child(propertyName)
	
	# The parent PropertyField does not connect any signals, because it has no concept of what signal it should be emitting to where

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getNameObject():
	return propertyName

func getDefinition() -> Property:
	return definition

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
