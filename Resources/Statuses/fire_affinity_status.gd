class_name FireAffinityStatus
extends Status

func _init(target_entity : Targetable, stacks : int) -> void:
	super(target_entity, stacks)
	type = StatusUtils.names.STRENGTH

func on_turn_start() -> void:
	if target_entity is PlayerStats:
		for i in range(stacks):
			target_entity.companion_stats.add_orb(CardUtils.magic_type.FIRE)
