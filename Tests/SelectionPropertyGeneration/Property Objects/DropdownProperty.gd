extends Property
class_name DropdownProperty

export(PoolStringArray) var options setget noChange, getOptions

func _init(name : String, command : String, optionList : Array).(Property.PropertyTypes.DROPDOWN_PROPERTY, name, command):
	options = PoolStringArray(optionList)	

func noChange(_value):
	pass

func getOptions() -> PoolStringArray :
	return options
