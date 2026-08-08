extends CardData

# attack
func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.ENEMY]

func channel_add() -> Array[CardUtils.magic_type]:
	return [CardUtils.magic_type.FIRE]
