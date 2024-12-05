extends PropertyField
class_name SeperatorPropertyField

# Member Variables Here
var line

# Class Initialization
func _init(obj : DraggableObject, property : SeperatorProperty).(obj,property):
	line = HSeparator.new()
	add_child(line)
	self.propertyName.queue_free()
	line.size_flags_horizontal = SIZE_EXPAND_FILL

# this was the first way I tried, but it's not very good
#func _ready():
#	# the initialization doesn't add it to the tree, so it does not have a parent to use to determine how wide it should be
#	# therefore, we change the size only after it's added to the tree
#	# we use whatever width the parent has and just fill that up
#	line.rect_min_size.x = self.get_parent().get_rect().size.x

# Other functions, as required
