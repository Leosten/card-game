class_name StunStatus
extends Status

func _init(target_entity : Targetable) -> void:
	super(target_entity, 0)
	type = StatusUtils.names.STUN

func on_turn_start() -> void:
	stacks = 0
