extends CardData

# defend
func _init():
	actions = [CardUtils.action_type.SHIELD]
	allowed_targets = [CardUtils.targets.SELF]
