class_name CharacterUtils

extends Node

static func get_current_mana(battle_state : BattleState) -> int:
	return battle_state.player_stats.current_mana
	
static func reduce_current_mana(battle_state : BattleState, cost):
	var new_mana = get_current_mana(battle_state) - cost
	battle_state.player_stats.current_mana = new_mana
	
static func replenish_mana(player_stats: PlayerStats):
	player_stats.current_mana = player_stats.max_mana
