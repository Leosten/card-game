class_name Buff

extends Status

@export var type : StatusUtils.buffs

func _init(p_type : StatusUtils.buffs = StatusUtils.buffs.PERFECT_PROTECT, p_quantity : int = 0, quantity_cumulative: bool = false, p_duration: int = 0, duration_cumulative: bool = false) -> void:
	super(p_quantity, quantity_cumulative, p_duration, duration_cumulative)
	type = p_type

func turn_effect(battle_state: BattleState):
	pass
