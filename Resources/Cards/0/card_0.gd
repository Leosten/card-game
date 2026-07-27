extends CardData

# card 0 attacks
func use(battle_state : Dictionary, enemy_position):
	var enemy : MonsterData = MonsterUtils.find_monster_by_position(battle_state, enemy_position)
	var final_damage = DamageUtils.calculate_ally_final_damage(damage, battle_state["player_stats"], enemy)
	print("card damage " + str(final_damage))
	enemy = DamageUtils.damage_enemy(final_damage, enemy)
	print("enemy health " + str(enemy.health))

	battle_state = MonsterUtils.update_monster_by_position(battle_state, enemy, enemy_position)
	
	return battle_state
