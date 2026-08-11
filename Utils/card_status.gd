class_name CardStatus

var type : StatusUtils.names
var stacks : int
func _init(s_type : StatusUtils.names, c_stack : int) -> void:
	type = s_type
	stacks = c_stack
