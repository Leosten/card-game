class_name ActionManager
extends Node

signal update_battle_state

func _ready() -> void:
	pass

func use_card_on_enemy(
	card : CardData,
	battle_state: Dictionary,
	enemy_position
	):
	if (card.allowed_targets.get("ENEMY") == 0):
		print("ERROR : target not allowed")
		return battle_state
	print("card used on monster %s" % str(enemy_position))
	return card.cardFunctionality(battle_state, enemy_position)

func use_card_on_all_enemies():
	pass

func use_card_on_character(
	card_data : CardData, 
	player_stats : PlayerStats
	):
		pass

func effect_enemy_by_action(action, enemy: MonsterData, value):
	pass

func damage(enemy, value):
	if (enemy.shield > 0):
		pass

func shield_damage():
	pass
func heal():
	pass
