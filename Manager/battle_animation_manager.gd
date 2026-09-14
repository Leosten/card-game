class_name BattleAnimationManager
 
extends Node

var short_pause_value = 0.5

func monster_appears(monster: Monster):
	pass

func short_pause():
	get_parent().get_tree().create_timer(short_pause_value).timeout.emit()
