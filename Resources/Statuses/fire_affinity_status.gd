class_name FireAffinityStatus
extends Status

func _init(target : Targetable, initial_stacks : int) -> void:
	super(target, initial_stacks)
	type = StatusUtils.names.FIRE_AFFINITY

func on_turn_start() -> void:
	if target_entity is PlayerStats:
		for i in range(stacks):
			target_entity.companion_stats.add_orb(CardUtils.magic_type.FIRE)
