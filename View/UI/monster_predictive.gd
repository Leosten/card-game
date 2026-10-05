extends Node2D

@onready var icon = %Icon
@onready var label = %PredictiveLabel

func _ready():
	pass

func update(monster_act : MonsterAction):
	print("monster action name :" , monster_act.name)
	icon.texture = GameManager.ui_manager.get_monster_action_icon(monster_act.type)	
	get_label_by_action(monster_act)

func get_label_by_action(monster_act: MonsterAction):
	label.show()
	match monster_act.type:
		MonsterUtils.action_types.DAMAGE:
			label.text = str(monster_act.damage)
		MonsterUtils.action_types.DAMAGE_STATUS:
			label.hide()
		MonsterUtils.action_types.SHIELD:
			label.text = str(monster_act.shield)
		MonsterUtils.action_types.HEAL_SELF, MonsterUtils.action_types.HEAL_OTHERS:
			label.text = monster_act.heal
		MonsterUtils.action_types.BUFF, MonsterUtils.action_types.BUFF_OTHERS:
			label.hide()
		MonsterUtils.action_types.HEAVY_DAMAGE:
			label.text = monster_act.damage
		_:
			label.hide()
