class_name StatusEffect

extends Status

@export var type : StatusUtils.status_effects

func _init(p_type : StatusUtils.status_effects = StatusUtils.status_effects.VULNERABLE, p_quantity : int = 0, quantity_cumulative: bool = false, p_duration: int = 0, duration_cumulative: bool = false) -> void:
	super(p_quantity, quantity_cumulative, p_duration, duration_cumulative)
	type = p_type
