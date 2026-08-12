@abstract class_name StatusUtils
extends Node

enum names { 
	DRAW,
	PERFECT_PROTECT,
	STRENGTH,
	REGEN,
	STUN,
	VULNERABLE,
	FIRE_AFFINITY,
	ICE_AFFINITY,
	WIND_AFFINITY
}

static func apply_strength_modifier(damage, stacks):
	return damage + stacks

static func apply_vulnerable_modifier(damage):
	var final_dmg = damage + damage * 25 / 100
	return final_dmg

static func apply_defense_modifiers(damage_value, status_effects : Dictionary) :
	if status_effects.has(StatusUtils.names.VULNERABLE) :
		damage_value = apply_vulnerable_modifier(damage_value)
	return damage_value

static func apply_attack_modifiers(damage_value : int, buffs : Dictionary) :
	if buffs.has(StatusUtils.names.STRENGTH) :
		damage_value = apply_strength_modifier(damage_value, buffs[StatusUtils.names.STRENGTH])
	return damage_value

static func action_possible(target : Targetable) -> bool:
	if target.status_manager.get_statuses().has(StatusUtils.names.STUN):
		return false
	return true
