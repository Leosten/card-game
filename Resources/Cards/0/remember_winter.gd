extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_ADD, CardUtils.action_type.DRAW]
	allowed_targets = [CardUtils.targets.SELF, CardUtils.targets.ALLY]

func channel_add():
	return CompanionUtils.add_orbs(CardUtils.magic_type.ICE, channel_add_value)
