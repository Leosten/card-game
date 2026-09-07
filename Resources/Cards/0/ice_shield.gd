extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_ADD, CardUtils.action_type.SHIELD]
	allowed_targets = [CardUtils.targets.SELF]

func channel_add() -> Array[CardUtils.magic_type]:
	return CompanionUtils.add_orbs(CardUtils.magic_type.ICE, channel_add_value)
