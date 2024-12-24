extends Object
class_name TableDim

var long_dim : float
var short_dim : float

func _init(l_or_d : float, w_or_r : float = l_or_d/2):
	long_dim = l_or_d
	short_dim = w_or_r

func length() -> float:
	return long_dim

func diameter() -> float:
	return long_dim

func width() -> float:
	return short_dim

func radius() -> float:
	return long_dim/2
