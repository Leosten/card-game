class_name CharacterUtils

extends Node

static func get_current_mana(battle_state) -> int:
	return battle_state["player_stats"].current_mana
	
static func reduce_current_mana(battle_state, cost) -> Dictionary:
	var new_mana = get_current_mana(battle_state) - cost
	battle_state["player_stats"].current_mana = new_mana
	return battle_state
	
static func replenish_mana(battle_state) -> Dictionary:
	battle_state["player_stats"].current_mana = battle_state["player_stats"].max_mana
	return battle_state
