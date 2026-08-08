extends CardData

# Heal
func _init():
	actions = [CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.DRAW]
	allowed_targets = [CardUtils.targets.SELF, CardUtils.targets.ALLY]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_last_orb_channeled(orbs)
	return orbs

func conditions_check(battle_state : BattleState) -> bool:
	print("check heal condition ",  CardUtils.orbs_not_empty(battle_state.companion_stats.channel_orbs))
	return CardUtils.orbs_not_empty(battle_state.companion_stats.channel_orbs)
