class_name VulnerableStatus

extends StatusTemplate

func _init(target : Targetable, initial_stacks) -> void:
	super(target, initial_stacks)
	type = StatusUtils.names.VULNERABLE

func on_turn_end() -> void:
	stacks -= 1
