extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.SELF, CardUtils.targets.ALLY]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_last_orb_channeled(orbs, channel_remove_value)
	return orbs

func conditions_check(battle_state : BattleState) -> bool:
	var orbs : Array[CardUtils.magic_type] = battle_state.player_stats.companion_stats.channel_orbs
	if CompanionUtils.orbs_not_empty(orbs) != true:
		return false
	if orbs.size() < channel_remove_value:
		return false
	return true

func channel_add() -> Array[CardUtils.magic_type]:
	return CompanionUtils.add_orbs(CardUtils.magic_type.FIRE, channel_add_value)
