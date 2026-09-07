extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.SELF, CardUtils.targets.ALLY]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_orb_by_type(orbs, CardUtils.magic_type.FIRE, channel_remove_value)
	return orbs

func conditions_check(battle_state : BattleState) -> bool:
	var orbs = battle_state.player_stats.companion_stats.channel_orbs
	if CompanionUtils.orbs_not_empty(orbs) != true:
		return false
	if CompanionUtils.has_at_least_by_type(
		orbs,
		CardUtils.magic_type.FIRE, channel_remove_value) != true:
		return false
	return true

func channel_add() -> Array[CardUtils.magic_type]:
	return CompanionUtils.add_orbs(CardUtils.magic_type.ICE, channel_add_value)
