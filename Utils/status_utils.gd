@abstract class_name StatusUtils
extends Node

enum buffs { DRAW, PERFECT_PROTECT, STRENGTH, VITALITY}
enum status_effects {STUN, VULNERABLE}

static func get_strength_modifier(damage, strength : Buff):
	return damage + strength.quantity

static func get_vulnerable_modifier(damage, vulnerable_status : StatusEffect):
	var final_dmg = damage + damage * 25 / 100
	return final_dmg

static func apply_status_effects(target: Targetable, status_effects : Array[StatusEffect]) -> Targetable:
	for effect in status_effects:
		var existing_effect = StatusUtils.get_status_effect_or_null(target.status_effects, effect.type)
		if existing_effect != null :
			# if its a single turn effect
			if effect.quantity_cumulative == true and effect.duration_cumulative == true:
				return target
			if effect.quantity_cumulative == true:
				existing_effect.quantity += effect.quantity
			if effect.duration_cumulative == true:
				existing_effect.duration += effect.duration
			target.statused.emit(effect)
			return target
		print("added effect")
		target.status_effects.append(effect)
		print(target.status_effects)
		target.statused.emit(effect)
	return target

static func apply_buffs(target : Targetable, buffs : Array[Buff]) -> Targetable:
	for buff in buffs:
		var existing_buff = StatusUtils.get_buff_or_null(target.buffs, buff.type)
		if existing_buff != null :
			if buff.quantity_cumulative == true and buff.duration_cumulative == true:
				return target
			if buff.quantity_cumulative == true:
				existing_buff.quantity += buff.quantity
			if buff.duration_cumulative == true:
				existing_buff.duration += buff.duration
			target.buffed.emit(buff)
			return target
		target.buffs.append(buff)
	return target

static func apply_defense_modifiers(damage_value, status_effects) :
	for status in status_effects:
		if status.type == StatusUtils.status_effects.VULNERABLE :
			print("vulnerable found")
			damage_value = get_vulnerable_modifier(damage_value, status)
	return damage_value

static func apply_attack_modifiers(damage_value, buffs) :
	for buff in buffs:
		if buff.type == StatusUtils.buffs.STRENGTH :
			damage_value = get_strength_modifier(damage_value, buff)
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

func get_status_icons():
	var icons = []
	#for buff in StatusUtils.buffs:
		#var icon = Button.new()
