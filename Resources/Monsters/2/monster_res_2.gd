extends MonsterData

func _init():
	super()
	action_cycle = [
		MonsterAction.new("attack", MonsterUtils.action_types.SHIELD, 5)
	]
	print('cycle set')
