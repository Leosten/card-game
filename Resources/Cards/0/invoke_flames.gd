extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.SELF]

func channel_add() -> Array[CardUtils.magic_type]:
	return CompanionUtils.add_orbs(CardUtils.magic_type.FIRE, channel_add_value)
