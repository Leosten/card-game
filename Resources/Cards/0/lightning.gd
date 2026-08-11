extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.STATUS_EFFECTS]
	status_effects = [StatusEffect.new(StatusUtils.status_effects.STUN, 0, false, 0, false)]
	allowed_targets = [CardUtils.targets.ENEMY]
