extends MonsterData

func _init():
	super()
	action_cycle = [
		MonsterAction.new("attack", MonsterUtils.action_types.DAMAGE, 4)
	]
