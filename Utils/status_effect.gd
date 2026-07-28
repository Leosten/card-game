class_name StatusEffect

extends Resource

var type : StatusUtils.status_effects
var quantity : int = 0

func _init(p_type : StatusUtils.status_effects, p_quantity : int) -> void:
	type = p_type
	quantity = p_quantity
