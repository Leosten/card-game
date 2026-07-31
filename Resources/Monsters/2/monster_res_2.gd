extends MonsterData

func _init():
	super()
	action_cycle = [
		MonsterAction.new("defend", MonsterUtils.action_types.SHIELD, 2, 2)
	]
	print('cycle set')
