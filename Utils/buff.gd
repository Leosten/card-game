class_name Buff

extends Status

@export var type : StatusUtils.buffs

func _init(p_type : StatusUtils.buffs, p_quantity : int, quantity_cumulative: bool, p_duration: int, duration_cumulative: bool) -> void:
	super(p_quantity, quantity_cumulative, p_duration, duration_cumulative)
	type = p_type
