extends CardData

func _init():
	actions = [CardUtils.action_type.BUFFS]
	allowed_targets = [CardUtils.targets.ENEMY]
	var enchantment = Buff.new(StatusUtils.buffs.ENCHANTMENT, 0, false, 0, false)
	enchantment.turn_effect = Callable(turn_effect)
	buffs = [Buff.new(StatusUtils.buffs.ENCHANTMENT, 0, false, 0, false)]

func channel_add() -> Array[CardUtils.magic_type]:
	#return [CardUtils.magic_type.FIRE]
	return [CardUtils.magic_type.FIRE,CardUtils.magic_type.FIRE,CardUtils.magic_type.FIRE]

func turn_effect():
	channel_add()
