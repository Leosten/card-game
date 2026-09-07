extends CardData

func _init():
	actions = [CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.SELF]

func channel_add() -> Array[CardUtils.magic_type]:
	var orbs : Array[CardUtils.magic_type] = []
	for i in channel_add_value:
		orbs.append(CardUtils.magic_type.values().pick_random())
	return orbs
