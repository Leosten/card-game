extends CardData

func use(battle_state : Dictionary, enemy_position):
	var enemy : MonsterData = battle_state.get("level_monsters")[enemy_position]
	var final_damage = DamageUtils.calculate_final_damage(damage, battle_state["player_stats"], enemy)

	enemy = DamageUtils.damage_enemy(final_damage, enemy)

	battle_state["level_monsters"][enemy_position] = enemy
	return battle_state
