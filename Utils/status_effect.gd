class_name StatusEffect

extends Resource

@export var type : StatusUtils.status_effects
@export var quantity : int = 0
@export var duration: int = 0
@export var duration_cumulative = false
@export var quantity_cumulative = false

func _init(p_type : StatusUtils.status_effects, p_quantity : int, quantity_cumulative: bool, p_duration: int, duration_cumulative: bool) -> void:
	type = p_type
	quantity = p_quantity
	duration = p_duration
	duration_cumulative = duration_cumulative
	quantity_cumulative = quantity_cumulative
