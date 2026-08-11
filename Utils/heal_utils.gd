class_name HealUtils
extends Node

static func calculate_final_heal(heal_value, target : Targetable):
	return heal_value

static func apply_heal(heal_value, target : Targetable):
	target.health += heal_value

static func calculate_final_shield(shield_value, target : Targetable):
	# todo : check for items or particular buffs -> scaling
	return shield_value

static func apply_shield(shield_value, target : Targetable):
	print("apply shield %s" % str(shield_value))
	target.shield += shield_value
