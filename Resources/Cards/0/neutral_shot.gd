extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.CHANNEL_REMOVE, CardUtils.action_type.DRAW]
	allowed_targets = [CardUtils.targets.ENEMY]

func channel_remove(orbs: Array[CardUtils.magic_type]):
	orbs = CompanionUtils.remove_last_orb_channeled(orbs, channel_remove_value)
	return orbs
