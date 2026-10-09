extends MonsterData

func _init():
	super()
	set_monster_actions()
	
func set_monster_actions():
	var attack_action = MonsterAction.new("attack", MonsterUtils.action_types.DAMAGE, 4)
	var move_action = MonsterAction.new("move", MonsterUtils.action_types.MOVE_TARGET)
	attack_action.set_area_of_effect(AreaEffectUtils.pattern_pierce_v(10), AreaEffectUtils.pattern_origin_left_middle())

	action_cycle = [
		attack_action,
		move_action
	]
