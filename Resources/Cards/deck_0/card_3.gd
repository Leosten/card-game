extends CardData

# weaken
func _init():
	actions = [CardUtils.action_type.STATUS_EFFECTS, CardUtils.action_type.DAMAGE]
	status_effects = [StatusEffect.new(StatusUtils.status_effects.VULNERABLE, 0, false, 2, true)]
	allowed_targets = [CardUtils.targets.ENEMY]
