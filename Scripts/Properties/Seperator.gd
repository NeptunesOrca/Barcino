#meta-name: New SelectionProperty
#meta-description: Template for creating a new SelectionProperty. Will automatically append "Property" to the end of whatever name is given
extends SelectionProperty
class_name SeperatorProperty
## The [SelectionProperty] used to generate [SeperatorPropertyField].
##
## Dictates the properties of a [SeperatorPropertyField]. 
#region Constants

#endregion

#region Member Variables

#endregion

#region Initialization
## Class Initialization
func _init(name := ""):
	super(-1, name, "")
	#Seperator has no properties or data, it's just a horizontal line used to mark a seperation of some kind
	#The name is not displayed, and only used for programmers to be able to use if they want
#endregion

#region Functions

#endregion
