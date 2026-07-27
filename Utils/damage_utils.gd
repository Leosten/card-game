@abstract class_name DamageUtils

extends Node

static func damage_enemy(damage_value, monster: MonsterData):
	if has_monster_protective_buff(monster):
		return monster

	if monster.shield > 0:
		if (damage_value >= monster.shield):
			var current_shield = monster.shield
			monster.shield = 0 
			monster.health -= damage_value - current_shield
			return monster
		else:
			monster.shield -= damage_value
			return monster
	else:
		monster.health -= damage_value

	monster = check_for_death(monster)	
	return monster

static func damage_player(damage_value, player_stats : PlayerStats):
	if has_ally_protective_buff(player_stats):
		return player_stats
		
	if player_stats.shield > 0:
		if (damage_value >= player_stats.shield):
			var current_shield = player_stats.shield
			player_stats.shield = 0 
			player_stats.health -= damage_value - current_shield
		else:
			player_stats.shield -= damage_value
			return player_stats
	else:
		player_stats.health -= damage_value
	
	check_for_player_death(player_stats)
	return player_stats

# ALLY
static func has_ally_protective_buff(player_stats : PlayerStats):
	if player_stats.buffs.get(StatusUtils.buffs.PERFECT_PROTECT):
		return player_stats

static func ally_has_damage_modifier(damage_value, player_stats : PlayerStats):
	if player_stats.buffs.STRENGTH > 0:
		damage_value = StatusUtils.get_strength_modifier(damage_value, player_stats.buffs.STRENGTH)
	return damage_value

static func ally_has_defense_modifier(damage_value, player_stats : PlayerStats):
	if player_stats.buffs.STRENGTH > 0:
		damage_value = damage_value + player_stats.buffs.get(StatusUtils.buffs.STRENGTH)
	return damage_value

static func calculate_ally_final_damage(damage_value, player_stats: PlayerStats, enemy: MonsterData):
	var final_damage = DamageUtils.ally_has_damage_modifier(damage_value, player_stats)
	final_damage = enemy_has_defense_modifier(final_damage, enemy)
	return final_damage

static func check_for_player_death(player_stats):
	if (player_stats.health <= 0):
		player_stats.health = 0
		print("Player dead")
		Events.player_death.emit()
	return player_stats

# ENEMY
static func enemy_has_attack_modifier(damage_value, monster : MonsterData):
	if monster.buffs.STRENGTH > 0:
		damage_value = StatusUtils.get_strength_modifier(damage_value, monster.buffs.get(StatusUtils.buffs.STRENGTH))
	return damage_value

static func enemy_has_defense_modifier(damage_value, monster : MonsterData):
	if monster.status_effects.VULNERABLE > 0:
		damage_value = StatusUtils.get_vulnerable_modifier(damage_value, monster.buffs.get(StatusUtils.status_effects.VULNERABLE))
	return damage_value

static func has_monster_protective_buff(monster: MonsterData):
	if monster.buffs.PERFECT_PROTECT > 0:
		return monster

static func calculate_enemy_final_damage(damage_value, player_stats: PlayerStats, enemy: MonsterData):
	var final_damage = DamageUtils.enemy_has_attack_modifier(damage_value, enemy)
	final_damage = ally_has_damage_modifier(final_damage, player_stats)
	return final_damage
	
static func check_for_death(monster: MonsterData):
	if (monster.health <= 0):
		monster.health = 0
	print("enemy %s dead" % monster.battle_position)
	return monster
