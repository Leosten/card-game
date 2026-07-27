@abstract class_name DamageUtils

extends Node

static func damage_enemy(damage_value, monster: MonsterData):
	if has_protective_buff(monster):
		return monster

	if monster.shield > 0:
		if (damage_value >= monster.shield):
			var current_shield = monster.shield
			monster.shield = 0 
			monster.health -= damage_value - current_shield
		else:
			monster.shield -= damage_value
		return monster
	else:
		monster.health -= damage_value

	monster = check_for_death(monster)	
	return monster

static func damage_player():
	pass

static func has_protective_buff(monster: MonsterData):
	if monster.buffs.get(StatusUtils.buffs.PERFECT_PROTECT):
		return monster

static func enemy_has_modifier(damage_value, monster : MonsterData):
	if monster.buffs.get(StatusUtils.status_effects.VULNERABLE > 0):
		damage_value = damage_value - (25 / 100)
	return damage_value

static func ally_has_modifier(damage_value, player_stats : PlayerStats):
	if player_stats.buffs.STRENGTH > 0:
		damage_value = damage_value + player_stats.buffs.get(StatusUtils.buffs.STRENGTH)
	return damage_value

static func calculate_final_damage(damage_value, player_stats: PlayerStats, enemy: MonsterData):
	var final_damage = DamageUtils.ally_has_modifier(damage_value, player_stats)
	final_damage = enemy_has_modifier(final_damage, enemy)
	return final_damage

static func check_for_death(monster: MonsterData):
	if (monster.health <= 0):
		monster.health = 0
	print("check for death")
	return monster
