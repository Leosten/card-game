class_name Buff

extends Resource

var type : StatusUtils.buffs
var quantity : int

func _init(p_type : StatusUtils.buffs, p_quantity : int) -> void:
	type = p_type
	quantity = p_quantity
