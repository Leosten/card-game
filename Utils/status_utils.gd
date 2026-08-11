@abstract class_name StatusUtils
extends Node

enum buffs { DRAW, PERFECT_PROTECT, STRENGTH, VITALITY, ENCHANTMENT}
enum status_effects {STUN, VULNERABLE}

static func get_strength_modifier(damage, strength : Buff):
	return damage + strength.quantity

static func get_vulnerable_modifier(damage, vulnerable_status : StatusEffect):
	var final_dmg = damage + damage * 25 / 100
	return final_dmg

static func apply_status_effects(target: Targetable, status_effects : Array[StatusEffect]) -> Targetable:
	for effect in status_effects:
		var existing_effect = StatusUtils.get_status_or_null(target.status_effects, effect.type)
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
		target.status_effects.append(effect.duplicate(true))
		target.statused.emit(effect)
	return target

static func apply_buffs(target : Targetable, buffs : Array[Buff]) -> Targetable:
	for buff in buffs:
		var existing_buff = StatusUtils.get_status_or_null(target.buffs, buff.type)
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
			damage_value = get_vulnerable_modifier(damage_value, status)
	return damage_value

static func apply_attack_modifiers(damage_value, buffs) :
	for buff in buffs:
		if buff.type == StatusUtils.buffs.STRENGTH :
			damage_value = get_strength_modifier(damage_value, buff)
	return damage_value

static func get_status_or_null(statuses : Array[Status], status_to_find : Variant):
	for status in statuses:
		if status.type == status_to_find:
			return status
	return null

static func check_for_status_cycle(statuses :Array[Status], status: Status):
	if status is Buff:
		if status.type == StatusUtils.buffs.ENCHANTMENT:
			status.turn_effect(GameManager.battle_state)
	if status.duration_cumulative == true:
		status.duration -= 1
	if status.quantity_cumulative == true:
		status.quantity -= 1
	if (status.duration_cumulative == false and status.quantity_cumulative == false ):
		statuses.erase(status)

static func action_possible(target : Targetable):
	if target.status_effects.is_empty() == true:
		return true
