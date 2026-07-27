@abstract class_name StatusUtils
extends Node

enum buffs { DRAW = 0, PERFECT_PROTECT = 0, STRENGTH = 0}
enum status_effects {STUN = 0, VULNERABLE = 0}

static func get_strength_modifier(damage, strength_value):
	return damage + strength_value
