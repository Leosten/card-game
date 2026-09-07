extends CardData

func _init():
	actions = [CardUtils.action_type.BUFFS]
	buffs = [CardStatus.new(StatusUtils.names.FIRE_AFFINITY, 1, channel_add_value)]
	allowed_targets = [CardUtils.targets.SELF]
