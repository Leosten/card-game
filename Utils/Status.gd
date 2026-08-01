class_name Status

extends Resource

@export var quantity : int = 0
@export var duration: int = 0
@export var duration_cumulative = false
@export var quantity_cumulative = false

func _init(p_quantity : int = 0, quantity_cumulative: bool = false, p_duration: int = 0, duration_cumulative: bool = false) -> void:
	quantity = p_quantity
	duration = p_duration
	duration_cumulative = duration_cumulative
	quantity_cumulative = quantity_cumulative
