class_name CardStatus

var type : StatusUtils.names
var stacks : int
var modifiable_value : int

func _init(s_type : StatusUtils.names, c_stack : int, m_value : int = 0) -> void:
	type = s_type
	stacks = c_stack
	modifiable_value = m_value
