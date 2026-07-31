class_name StatusEffect

extends Status

@export var type : StatusUtils.status_effects

func _init(p_type : StatusUtils.status_effects, p_quantity : int, quantity_cumulative: bool, p_duration: int, duration_cumulative: bool) -> void:
	super(p_quantity, quantity_cumulative, p_duration, duration_cumulative)
	type = p_type
