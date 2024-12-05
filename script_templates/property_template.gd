extends Property
class_name %CLASS%Property

# Member Variables Here
export(%TYPE%) var %VARNAME% setget noChange, %FUNCNAME%

# Class Initialization
func _init():
	pass

func noChange(_value):
	pass

func %FUNCNAME%() -> %TYPE%:
	return %VARNAME%

# Other functions, as required
