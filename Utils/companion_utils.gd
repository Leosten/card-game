class_name CompanionUtils
extends Node

enum companion_type { ELEMENTAL }

static func remove_orb_by_type(channel_orbs, type, nb) -> Array[CardUtils.magic_type]:
	for orb in channel_orbs:
		if nb == 0:
			return channel_orbs
		if orb == type:
			channel_orbs.erase(orb)
			nb -= 1
	return channel_orbs
	
static func remove_last_orb_channeled(channel_orbs : Array[CardUtils.magic_type]) -> Array[CardUtils.magic_type]:
	channel_orbs.pop_back()
	return channel_orbs
	
