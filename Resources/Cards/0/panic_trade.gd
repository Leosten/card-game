extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.SELF, CardUtils.targets.ALLY]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_orb_by_type(orbs, CardUtils.magic_type.FIRE, 2)
	return orbs

func conditions_check(battle_state : BattleState) -> bool:
	return CompanionUtils.orbs_not_empty(battle_state.player_stats.companion_stats.channel_orbs)
	
func channel_add() -> Array[CardUtils.magic_type]:
	return [CardUtils.magic_type.ICE,CardUtils.magic_type.ICE]
