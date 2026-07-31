class_name Status

extends Resource

@export var quantity : int = 0
@export var duration: int = 0
@export var duration_cumulative = false
@export var quantity_cumulative = false

func _init(p_quantity : int, quantity_cumulative: bool, p_duration: int, duration_cumulative: bool) -> void:
	quantity = p_quantity
	duration = p_duration
	duration_cumulative = duration_cumulative
	quantity_cumulative = quantity_cumulative
