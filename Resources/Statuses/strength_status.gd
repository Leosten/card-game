class_name StrengthStatus

extends Status

func _init(target_entity : Targetable, stacks : int) -> void:
	super(target_entity, stacks)
	type = StatusUtils.names.STRENGTH

func on_turn_end() -> void:
	stacks -= 1
