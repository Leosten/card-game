class_name VulnerableStatus
extends Status

func _init(target_entity : Targetable, stacks) -> void:
	super(target_entity, stacks)
	type = StatusUtils.names.VULNERABLE

func on_turn_end() -> void:
	stacks -= 1
