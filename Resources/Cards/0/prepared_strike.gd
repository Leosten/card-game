extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.DRAW]
	allowed_targets = [CardUtils.targets.ENEMY]
