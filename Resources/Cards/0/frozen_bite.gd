extends CardData

func _init():
	#GameManager.battle_state.companion_stats.channeled.connect(on_channeled)
	actions = [CardUtils.action_type.BUFFS]
	allowed_targets = [CardUtils.targets.SELF]
	buffs = [CardStatus.new(StatusUtils.names.FROZEN_BITE, 1, damage)]
