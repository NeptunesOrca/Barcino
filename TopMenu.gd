extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	get_tree().change_scene("res://Tests/DragAndDropTest1/DragAndDropTest1.tscn")


func _on_ObjCreateApproach2_pressed():
	get_tree().change_scene("res://Tests/ObjectCreationTestApproach2/ObjectCreationDragAndDrop_Approach2.tscn")

func _on_OOPDraggableClasses_pressed():
	get_tree().change_scene("res://Tests/OOPandDraggableClassesApproach2/OOPandDraggableClassesApproach2.tscn")

func _on_Adding_to_Layouts_pressed():
	get_tree().change_scene("res://Tests/Adding to Layout/AddToLayouts.tscn")

func _on_Repopulating_by_menu_parent_pressed():
	get_tree().change_scene("res://Tests/Repopulating by menu parent/RepopulateByMenuParent.tscn")

func _on_Changing_Layout_pressed():
	get_tree().change_scene("res://Tests/Change Venues/ChangeVenues.tscn")

func _on_SelectionPropGen_pressed():
	get_tree().change_scene("res://Tests/SelectionPropertyGeneration/SelectionPropertyGeneration.tscn")


func _on_Selecting_Draggable_Objects_pressed() -> void:
	get_tree().change_scene("res://Tests/SelectingDraggableObject/SelectingDraggableObject.tscn")
