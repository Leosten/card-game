extends CardData

# heavy blow
func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.STATUS_EFFECTS]
	status_effects = [StatusEffect.new(StatusUtils.status_effects.STUN, 1)]
	allowed_targets = [CardUtils.targets.ENEMY]
