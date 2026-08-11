extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.STATUS_EFFECTS]
	status_effects = [CardStatus.new(StatusUtils.names.STUN, 0)]
	allowed_targets = [CardUtils.targets.ENEMY]
