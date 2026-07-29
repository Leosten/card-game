class_name CharacterUtils

extends Node

static func get_current_mana(battle_state : BattleState) -> int:
	return battle_state.player_stats.current_mana
	
static func reduce_current_mana(battle_state : BattleState, cost) -> BattleState:
	var new_mana = get_current_mana(battle_state) - cost
	battle_state.player_stats.current_mana = new_mana
	return battle_state
	
static func replenish_mana(player_stats: PlayerStats) -> PlayerStats:
	player_stats.current_mana = player_stats.max_mana
	return player_stats
