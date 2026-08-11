extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.STATUS_EFFECTS]
	status_effects = []
	allowed_targets = [CardUtils.targets.ENEMY]
