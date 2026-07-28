class_name HealUtils
extends Node

static func calculate_ally_final_heal(heal_value, player_stats : PlayerStats):
	heal_value = apply_vitality(heal_value, player_stats.buffs)
	return heal_value
	
static func apply_ally_heal(heal_value, player_stats : PlayerStats):
	player_stats.health += heal_value
	return player_stats

static func calculate_ally_final_shield(shield_value, player_stats : PlayerStats):
	return shield_value

static func apply_ally_shield(shield_value, player_stats : PlayerStats):
	player_stats.shield += shield_value
	return player_stats

static func apply_vitality(heal_value, buffs) :
	var vitality = StatusUtils.get_buff_or_null(buffs, StatusUtils.buffs.VITALITY)
	if vitality != null :
		heal_value = heal_value + vitality.quantity
	return heal_value
