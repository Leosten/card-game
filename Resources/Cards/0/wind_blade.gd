extends CardData

func _init():
	actions = [CardUtils.action_type.STATUS_EFFECTS, CardUtils.action_type.DAMAGE]
	status_effects = [CardStatus.new(StatusUtils.names.VULNERABLE, status_stacks)]
	allowed_targets = [CardUtils.targets.ENEMY]
