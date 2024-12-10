extends Menu
class_name ControlMenu
## The parent object for both the object and venue menues.
##
## The logic of each individual tab is handled seperately by a different object, this just controls which tab is active
## [br]See [VenueController] for details about the Venues tab. The Objects tab does not currently use a script

#region Member Variables
#region Group Names
## The group name for [ControlMenu] so that it can easily be found
const objectMenuGroupName = "ObjectMenu"
#endregion

enum TabNumber {VENUES_TAB, OBJECTS_TAB}

## This is currently unusued, but may be used for printing
var availableFileTypes = [".png"]
#endregion

#region Startup
func _ready():
	add_to_group(objectMenuGroupName)
#endregion

#region Tab Control
## Switches which tab is active in the menu, specified by [param tabnum] which belongs to [enum TabNumber]
func switchMenuTab(tabnum : TabNumber):
	set_current_tab(tabnum) #recall that Menu extends TabContainer, so set_current_tab is from TabContainer
	# we do not need the error handling to see if tabnum belongs to TabNumber from the original version, because GDScript2.0 allows typing by enums
	# I love GDScript2.0
#endregion

#region Printing
#TODO: printing stuff goes here
#endregion

#NOTE: the logic of each individual tab is handled seperately by a different object
# the ControlMenu just controls which tab is active, and they handle the rest
