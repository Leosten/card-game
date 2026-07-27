extends CardData

# card 0 attacks
func use(battle_state : Dictionary, enemy_position):
	var enemy : MonsterData = MonsterUtils.findMonsterByPosition(battle_state, enemy_position)
	var final_damage = DamageUtils.calculate_final_damage(damage, battle_state["player_stats"], enemy)
	print("card damage " + str(final_damage))
	enemy = DamageUtils.damage_enemy(final_damage, enemy)
	print("enemy health " + str(enemy.health))

	battle_state = MonsterUtils.updateMonsterByPosition(battle_state, enemy, enemy_position)
	
	return battle_state
