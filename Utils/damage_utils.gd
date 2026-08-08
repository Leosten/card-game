@abstract class_name DamageUtils

static func apply_damage(damage_value, target : Targetable):
	if has_protective_buff(target.buffs):
		target.damage_protected.emit()

	if target.shield > 0:
		if (damage_value == target.shield):
			target.shield = 0
			target.shield_broken.emit()
			target.stats_changed.emit()
			return
		if (damage_value >= target.shield):
			var current_shield = target.shield
			target.shield = 0
			var final_damage = damage_value - current_shield
			target.health -= final_damage
			target.shield_broken.emit()
			target.damage_taken.emit(final_damage)
			target.stats_changed.emit()
			return
		else:
			target.shield -= damage_value
			target.damage_shielded.emit(damage_value)
			target.stats_changed.emit()
			return
	target.health -= damage_value
	target.damage_taken.emit(damage_value)
	check_for_death(target)
	print("target damaged")
	target.stats_changed.emit()

static func has_attack_modifier(damage_value, attacker : Targetable):
	damage_value = StatusUtils.apply_attack_modifiers(damage_value, attacker.buffs)
	#to add : weak (dmg given -25%)
	return damage_value

static func has_defense_modifier(damage_value, target : Targetable):
	damage_value = StatusUtils.apply_defense_modifiers(damage_value, target.status_effects)
	#to add: armor (dmg taken -25%)
	return damage_value

static func calculate_final_damage(damage_value, attacker : Targetable, target: Targetable):
	var final_damage = has_attack_modifier(damage_value, attacker)
	final_damage = has_defense_modifier(final_damage, target)
	return final_damage

static func check_for_death(target : Targetable):
	if (target.health <= 0):
		target.health = 0
		target.death.emit()

static func has_protective_buff(buffs : Array[Status]) -> bool:
	var protect = StatusUtils.get_status_or_null(buffs, StatusUtils.buffs.PERFECT_PROTECT)
	if protect != null :
		return true
	return false
