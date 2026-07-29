@abstract class_name DamageUtils

static func damage_enemy(damage_value, monster: MonsterData):
	if has_protective_buff(monster.buffs):
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
	print("final dmg")
	print(damage_value)
	monster.health -= damage_value

	return monster

static func damage_player(damage_value, player_stats : PlayerStats) -> PlayerStats:
	if has_protective_buff(player_stats.buffs):
		return player_stats
		
	if player_stats.shield > 0:
		if (damage_value >= player_stats.shield):
			var current_shield = player_stats.shield
			player_stats.shield = 0 
			player_stats.health -= damage_value - current_shield
		else:
			player_stats.shield -= damage_value
			return player_stats
			
	player_stats.health -= damage_value
	check_for_player_death(player_stats)
	return player_stats

static func has_attack_modifier(damage_value, buffs, status_effects):
	damage_value = StatusUtils.apply_strength(damage_value, buffs)
	return damage_value

static func has_defense_modifier(damage_value, buffs, status_effects):
	damage_value = StatusUtils.apply_vulnerable(damage_value, status_effects)
	return damage_value

static func calculate_ally_final_damage(damage_value, player_stats: PlayerStats, enemy: MonsterData):
	var final_damage = has_attack_modifier(damage_value, player_stats.buffs, player_stats.status_effects)
	final_damage = has_defense_modifier(final_damage, enemy.buffs, enemy.status_effects)
	return final_damage

static func calculate_enemy_final_damage(damage_value, player_stats: PlayerStats, enemy: MonsterData):
	var final_damage = has_attack_modifier(damage_value, enemy.buffs, enemy.status_effects)
	final_damage = has_defense_modifier(final_damage, player_stats.buffs, player_stats.status_effects)
	return final_damage
	
static func check_for_player_death(player_stats : PlayerStats) -> PlayerStats:
	if (player_stats.health <= 0):
		player_stats.health = 0
		print("Player dead")
		Events.player_death.emit()
	return player_stats

static func has_protective_buff(buffs : Array[Buff]) -> bool:
	var protect = StatusUtils.get_buff_or_null(buffs, StatusUtils.buffs.PERFECT_PROTECT)
	if protect != null :
		return true
	return false
