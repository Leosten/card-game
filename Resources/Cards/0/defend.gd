extends CardData

func _init():
	actions = [CardUtils.action_type.SHIELD]
	allowed_targets = [CardUtils.targets.SELF]

func upgrade():
	shield = 12
