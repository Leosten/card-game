extends CardData

func _init():
	actions = [CardUtils.action_type.SHIELD, CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.SELF]

func channel_add() -> Array[CardUtils.magic_type]:
	return [CardUtils.magic_type.ICE, CardUtils.magic_type.ICE, CardUtils.magic_type.ICE]
