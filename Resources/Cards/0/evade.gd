extends CardData

func _init():
	actions = [CardUtils.action_type.MOVE_FROM_TARGET]
	allowed_targets = [CardUtils.targets.SELF]
	grid_target = CardUtils.grid_target.PLAYER
	area_pattern = AreaEffectUtils.pattern_single()
	area_origin = AreaEffectUtils.pattern_origin_middle()
