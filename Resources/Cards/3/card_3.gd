extends CardData

# weaken
func _init():
	actions = [CardUtils.action_type.STATUS_EFFECTS]
	status_effects = [StatusEffect.new(StatusUtils.status_effects.VULNERABLE, 2)]
	allowed_targets = [CardUtils.targets.ENEMY]
