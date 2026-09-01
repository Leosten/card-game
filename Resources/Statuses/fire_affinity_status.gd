class_name FireAffinityStatus

extends StatusTemplate

func _init(target : Targetable, initial_stacks : int) -> void:
	super(target, initial_stacks)
	type = StatusUtils.names.FIRE_AFFINITY

func on_turn_start() -> void:
	if target_entity is PlayerStats:
		if target_entity.companion_stats is ElementalCompanionStats:
			for i in range(stacks):
				var orbs : Array[CardUtils.magic_type] = [CardUtils.magic_type.FIRE]
				target_entity.companion_stats.add_orbs(orbs)
