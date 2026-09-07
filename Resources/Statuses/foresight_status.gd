class_name ForesightStatus

extends Status

func _init(target_entity : Targetable) -> void:
	super(target_entity, 1)
	type = StatusUtils.names.FORESIGHT

func on_turn_start() -> void:
	stacks = 0
