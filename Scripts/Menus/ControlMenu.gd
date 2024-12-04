extends Menu
class_name ControlMenu

enum TabNumber {VENUES_TAB, OBJECTS_TAB}

var availableFileTypes = [".png"]

func switchMenuTab(tabnum : TabNumber):
	set_current_tab(tabnum) #recall that Menu extends TabContainer, so set_current_tab is from TabContainer
	# we do not need the error handling to see if tabnum belongs to TabNumber from the original version, because GDScript2.0 allows typing by enums
	# I love GDScript2.0

#TODO: printing stuff goes here, or else somewhere else

#NOTE: the logic of each individual tab is handled seperately by a different object
# the ControlMenu just controls which tab is active, and they handle the rest
