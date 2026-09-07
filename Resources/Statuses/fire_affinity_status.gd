class_name FireAffinityStatus

extends Status
var add_value = 1

func _init(target : Targetable, initial_stacks : int, add_value_modified = 0) -> void:
	super(target, initial_stacks)
	type = StatusUtils.names.FIRE_AFFINITY
	if add_value_modified > 0:
		add_value = add_value_modified
		
func on_turn_start() -> void:
	if target_entity is PlayerStats:
		if target_entity.companion_stats is ElementalCompanionStats:
			for i in range(stacks):
				var orbs : Array[CardUtils.magic_type] = CompanionUtils.add_orbs(CardUtils.magic_type.FIRE, add_value)
				target_entity.companion_stats.add_orbs(orbs)
