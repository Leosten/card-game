extends CardData

# Heal
func _init():
	actions = [CardUtils.action_type.HEAL]
	allowed_targets = [CardUtils.targets.SELF, CardUtils.targets.ALLY]
