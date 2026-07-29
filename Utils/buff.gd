class_name Buff

extends Resource

@export var type : StatusUtils.buffs
@export var quantity : int
@export var duration: int
@export var duration_cumulative = false
@export var quantity_cumulative = false

func _init(p_type : StatusUtils.buffs, p_quantity : int, quantity_cumulative: bool, p_duration: int, duration_cumulative: bool) -> void:
	type = p_type
	quantity = p_quantity
	duration = p_duration
	duration_cumulative = duration_cumulative
	quantity_cumulative = quantity_cumulative
