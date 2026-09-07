extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.STATUS_EFFECTS, CardUtils.action_type.DAMAGE]
	allowed_targets = [CardUtils.targets.ENEMY]
	status_effects = [CardStatus.new(StatusUtils.names.VULNERABLE, status_stacks)]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_last_orb_channeled(orbs)
	return orbs

func conditions_check(battle_state : BattleState) -> bool:
	return CompanionUtils.orbs_not_empty(battle_state.player_stats.companion_stats.channel_orbs)
