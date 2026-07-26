extends CardData

func cardFunctionality(battle_state, enemy_position):
	var level_monsters = battle_state.get("level_monsters")
	if (level_monsters[enemy_position].shield > 0):
		level_monsters[enemy_position].shield -= 1
	else:
		level_monsters[enemy_position].health -= damage
		
	battle_state["level_monsters"] = level_monsters
	return battle_state
