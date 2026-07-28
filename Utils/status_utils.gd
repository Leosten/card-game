@abstract class_name StatusUtils
extends Node

enum buffs { DRAW, PERFECT_PROTECT, STRENGTH, VITALITY}
enum status_effects {STUN, VULNERABLE}

static func get_strength_modifier(damage, strength_value):
	return damage + strength_value

static func get_vulnerable_modifier(damage, vulnerable_value):
	var final_dmg = damage + damage * 25 / 100
	return final_dmg

static func apply_status_effects(target_status_effects : Array[StatusEffect], status_effects : Array[StatusEffect]) -> Array[StatusEffect]:
	for effect in status_effects:
		var existing_effect = StatusUtils.get_status_effect_or_null(target_status_effects, effect.type)
		if existing_effect != null :
			existing_effect.quantity += effect.quantity
			return target_status_effects
		target_status_effects.append(effect)
	return target_status_effects

static func apply_buffs(target_buffs : Array[Buff], buffs : Array[Buff]) -> Array[Buff]:
	for buff in buffs:
		var existing_buff = StatusUtils.get_buff_or_null(target_buffs, buff.type)
		if existing_buff != null :
			existing_buff.quantity += buff.quantity
			return target_buffs
		target_buffs.append(buff)
	return target_buffs

static func apply_vulnerable(damage_value, status_effects) :
	var vulnerable = StatusUtils.get_status_effect_or_null(status_effects, StatusUtils.status_effects.VULNERABLE)
	if vulnerable != null :
		print("vulnerable found")
		damage_value = get_vulnerable_modifier(damage_value, vulnerable.quantity)
	return damage_value

static func apply_strength(damage_value, status_effects) :
	var strength = StatusUtils.get_buff_or_null(status_effects, StatusUtils.buffs.STRENGTH)
	if strength != null :
		damage_value = get_strength_modifier(damage_value, strength.quantity)
	return damage_value

static func get_buff_or_null(buffs : Array[Buff], buff_to_find : StatusUtils.buffs):
	for buff in buffs:
		if buff.type == buff_to_find:
			return buff
	return null

static func get_status_effect_or_null(status_effects : Array[StatusEffect], status_effect_to_find : StatusUtils.status_effects):
	for status in status_effects:
		if status.type == status_effect_to_find:
			return status
	return null
