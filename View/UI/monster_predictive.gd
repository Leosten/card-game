extends Node2D

var monster_action : MonsterAction = null

@onready var icon = $AnchorPredictive/PredictivePanel/HBoxContainer/CenterContainer2/Icon
@onready var label = $AnchorPredictive/PredictivePanel/HBoxContainer/CenterContainer/PredictiveLabel

func update(monster_action : MonsterAction):
	icon.texture = GameManager.ui_manager.get_monster_action_icon(monster_action.type)	
	get_label_by_action(monster_action)
	
func get_label_by_action(monster_action: MonsterAction):
	label.show()
	match monster_action.type:
		MonsterUtils.action_types.DAMAGE:
			label.text = str(monster_action.damage)
		MonsterUtils.action_types.DAMAGE_STATUS:
			label.hide()
		MonsterUtils.action_types.SHIELD:
			label.text = str(monster_action.shield)
		MonsterUtils.action_types.HEAL_SELF, MonsterUtils.action_types.HEAL_OTHERS:
			label.text = monster_action.heal
		MonsterUtils.action_types.BUFF, MonsterUtils.action_types.BUFF_OTHERS:
			label.hide()
		MonsterUtils.action_types.HEAVY_DAMAGE:
			label.text = monster_action.damage
