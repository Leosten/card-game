class_name CompanionUtils
extends Node

enum companion_type { ELEMENTAL }

static func remove_orb_by_type(channel_orbs : Array[CardUtils.magic_type], type : CardUtils.magic_type, nb : int) -> Array[CardUtils.magic_type]:
	var removed_count: int = 0
	for index in range(channel_orbs.size() - 1, -1, -1):
		if channel_orbs[index] == type:
			channel_orbs.remove_at(index)
			removed_count += 1

			if removed_count >= nb:
				break
	return channel_orbs

static func remove_last_orb_channeled(channel_orbs : Array[CardUtils.magic_type], count : int = 1) -> Array[CardUtils.magic_type]:
	for i in count:
		channel_orbs.pop_back()
	return channel_orbs

static func orbs_not_empty(orbs : Array[CardUtils.magic_type]) -> bool:
	if orbs.size() <= 0:
		return false
	return true

static func has_at_least_by_type(channel_orbs : Array[CardUtils.magic_type], type: CardUtils.magic_type, nb):
	var fire_count: int = channel_orbs.count(type)
	if (fire_count < nb):
		return false
	return true

static func low_activation_check(companion_stats : ElementalCompanionStats, orb_count_activation: int) -> bool:
	if companion_stats.has_activation_ceiling(orb_count_activation):
		return true
	return false

static func add_orbs(type : CardUtils.magic_type, nb : int):
	var orbs = []
	for i in nb:
		orbs.append(type)
	return orbs
