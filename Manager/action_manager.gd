class_name ActionManager
extends Node

signal update_battle_state

func _ready() -> void:
	pass

func cost_card_mana(battle_state: Dictionary, card_cost) -> Dictionary:
	battle_state["player_stats"].current_mana -= card_cost
	return battle_state
	
func use_card_on_enemy(
	card : CardData,
	battle_state: Dictionary,
	enemy_position
	):
	if (card.allowed_targets.get("ENEMY") == 0):
		print("ERROR : target not allowed")
		return battle_state
	print("card used on monster %s" % str(enemy_position))
	
	battle_state = cost_card_mana(battle_state, card.cost)
	
	return card.use(battle_state, enemy_position)

func enemy_cycle(battle_state, enemy: MonsterData) -> Dictionary:
	battle_state = enemy.useAction(battle_state)
	enemy.cycle_step +=1
	enemy.reset_cycle_step()
	return battle_state

func use_card_on_all_enemies():
	pass

func use_card_on_character(
	card_data : CardData, 
	player_stats : PlayerStats
	):
		pass
