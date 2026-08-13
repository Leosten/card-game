class_name BattleAnimationManager
 
extends Node

var short_pause_value = 0.5

func monster_action_animation(monster : MonsterData, monsters_displayed : Array[Monster]) :
	var action_type = monster.getAction().type
	
	var monster_scene : Monster = MonsterUtils.find_monster_by_position(monsters_displayed, monster.battle_position)

	await monster_scene.play_action_animation(action_type)
	emit_signal("action_finished")

func monster_appears(monster: Monster):
	pass

func short_pause():
	get_parent().get_tree().create_timer(short_pause_value).timeout.emit()
