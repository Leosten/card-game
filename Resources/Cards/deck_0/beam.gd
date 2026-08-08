extends CardData

# attack
func _init():
	actions = [CardUtils.action_type.DAMAGE]
	allowed_targets = [CardUtils.targets.ENEMY]
