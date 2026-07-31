class_name HealUtils
extends Node

static func calculate_final_heal(heal_value, target : Targetable):
	heal_value = apply_vitality(heal_value, target.buffs)
	return heal_value
	
static func apply_heal(heal_value, target : Targetable):
	target.health += heal_value
	return target

static func calculate_final_shield(shield_value, target : Targetable):
	# todo : check for items or particular buffs -> scaling
	return shield_value

static func apply_shield(shield_value, target : Targetable):
	print("apply shield %s" % str(shield_value))
	target.shield += shield_value
	return target

static func apply_vitality(heal_value, buffs) :
	var vitality = StatusUtils.get_status_or_null(buffs, StatusUtils.buffs.VITALITY)
	if vitality != null :
		heal_value = heal_value + vitality.quantity
	return heal_value
