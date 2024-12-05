extends Object
class_name FileDetailsReturn

export var isValid := false
export var mode := FileDialog.MODE_SAVE_FILE
export var directory_location : String
export var filename_string : String

# Just in case there was ever a reason to extend this (I don't know why anyone would ever want to do that, you'd have to be high)
var className : String = "FileDetailsReturn" 

func _to_string() -> String:
	return "["+self.className+": " + str(self.get_instance_id()) +" {isValid: "+str(self.isValid)+", mode: "+str(mode)+", directory: "+self.directory_location+", filename: "+self.filename_string+"}]"
