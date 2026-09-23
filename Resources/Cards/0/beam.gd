extends CardData

func _init():
	actions = [CardUtils.action_type.DAMAGE]
	allowed_targets = [CardUtils.targets.ENEMY]
	grid_target = CardUtils.grid_target.ENEMY
	area_pattern = AreaEffectUtils.pattern_pierce_v()
	area_origin = AreaEffectUtils.pattern_origin_left_middle()
