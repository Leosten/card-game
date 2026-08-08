extends CardData

# attack
func _init():
	actions = [CardUtils.action_type.CHANNEL_USE]
	allowed_targets = [CardUtils.targets.SELF]
