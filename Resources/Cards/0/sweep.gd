extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.DAMAGE]
	allowed_targets = [CardUtils.targets.ALL_ENEMIES]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_last_orb_channeled(orbs, channel_remove_value)
	return orbs

func conditions_check(battle_state : BattleState) -> bool:
	return CompanionUtils.has_at_least(battle_state.player_stats.companion_stats.channel_orbs, channel_remove_value)
