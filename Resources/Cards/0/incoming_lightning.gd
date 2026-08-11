extends CardData

func _init():
	actions = [CardUtils.action_type.STATUS_EFFECTS, CardUtils.action_type.CHANNEL_ADD]
	status_effects = [StatusEffect.new(StatusUtils.status_effects.STUN, 0, false, 0, false)]
	allowed_targets = [CardUtils.targets.ENEMY]

func channel_add():
	return [CardUtils.magic_type.WIND, CardUtils.magic_type.WIND]
