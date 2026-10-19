extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE, CardUtils.action_type.CHANNEL_ADD]
	allowed_targets = [CardUtils.targets.ENEMY]
	grid_target = CardUtils.grid_target.ENEMY
	area_pattern = AreaEffectUtils.pattern_cross()
	area_origin = AreaEffectUtils.pattern_origin_middle()

func channel_add() -> Array[CardUtils.magic_type]:
	return CompanionUtils.add_orbs(CardUtils.magic_type.FIRE, channel_add_value)
