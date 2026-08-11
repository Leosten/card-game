extends CardData

func _init():
	actions = [CardUtils.action_type.STATUS_EFFECTS, CardUtils.action_type.DAMAGE]
	status_effects = [CardStatus.new(StatusUtils.names.VULNERABLE, 2)]
	allowed_targets = [CardUtils.targets.ENEMY]
