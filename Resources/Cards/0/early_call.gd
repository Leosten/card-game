extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_USE]
	allowed_targets = [CardUtils.targets.SELF]

func conditions_check(battle_state : BattleState) -> bool:
	return CompanionUtils.low_activation_check(battle_state.companion_stats, channel_remove_value)
