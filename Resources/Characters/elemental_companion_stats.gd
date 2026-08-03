class_name ElementalCompanionStats

extends CompanionStats

signal channeled
signal channel_used
signal channel_reset

@export var channel_orbs : Array[CardUtils.magic_type]= []
@export var max_channel_orbs = 5
@export var channel_activation_ceiling = 5
@export var channel_low_activation_ceiling = 3
@export var companion_type = CompanionUtils.companion_type.ELEMENTAL
@export var fire_high_damage = 25
@export var fire_low_damage = 15
@export var big_shield_value = 30
@export var low_shield_value = 15

func channel_add(card : Card):
	var orbs = card.channel()
	for orb in orbs:
		channel_orbs.append(orb)
		channeled.emit()

		if channel_orbs.size >= max_channel_orbs:
			channel_used.emit(channel_orbs)
			reset_channel_orbs()

func channel_remove(card : Card):
	channel_orbs = card.channel_remove()

func reset_channel_orbs():
	channel_orbs.clear()
	channel_reset.emit()

func check_orb_activation(battle_state : BattleState) -> BattleState:
	var fire_count = 0
	var ice_count = 0
	var wind_count = 0

	for orb in  channel_orbs:
		if orb == CardUtils.magic_type.FIRE:
			fire_count += 1
		if orb == CardUtils.magic_type.ICE:
			ice_count += 1
		if orb == CardUtils.magic_type.WIND:
			wind_count += 1
	# level 5 action
	if fire_count >= channel_activation_ceiling:
		explosion(battle_state)
		return battle_state
	if ice_count >= channel_activation_ceiling:
		big_shield(battle_state)
	if wind_count >= channel_activation_ceiling:
		aoe_stun(battle_state)
	return battle_state

func use_orb(battle_state : BattleState) -> BattleState:
	var fire_count = 0
	var ice_count = 0
	var wind_count = 0

	for orb in  channel_orbs:
		if orb == CardUtils.magic_type.FIRE:
			fire_count += 1
		if orb == CardUtils.magic_type.ICE:
			ice_count += 1
		if orb == CardUtils.magic_type.WIND:
			wind_count += 1
	# level 3 action
	if fire_count >= channel_low_activation_ceiling:
		aoe_explosion(battle_state)
		remove_orb_by_type(CardUtils.magic_type.FIRE, channel_low_activation_ceiling)
	if ice_count >= channel_low_activation_ceiling:
		small_shield(battle_state)
		remove_orb_by_type(CardUtils.magic_type.ICE, channel_low_activation_ceiling)
	if wind_count >= channel_low_activation_ceiling:
		aoe_vulnerable(battle_state)
		remove_orb_by_type(CardUtils.magic_type.WIND, channel_low_activation_ceiling)

	return battle_state

func remove_orb_by_type(type, nb):
	for orb in channel_orbs:
		if nb == 0:
			return
		if orb == type:
			channel_orbs.erase(orb)
			nb -= 1

func explosion(battle_state: BattleState):
	var monster_size = battle_state.level_monsters.size()
	var monster_index = randi_range(0, monster_size)
	DamageUtils.apply_damage(fire_high_damage, battle_state.level_monsters[monster_index])
	battle_state.level_monsters[monster_index].damage_taken.emit()
	
func aoe_explosion(battle_state: BattleState):
	for monster in battle_state.level_monsters:
		DamageUtils.apply_damage(fire_low_damage, monster)
		monster.damage_taken.emit()

func big_shield(battle_state: BattleState):
	HealUtils.apply_shield(big_shield_value, battle_state.player_stats)
	battle_state.player_stats.shielded.emit()

func small_shield(battle_state: BattleState):
	HealUtils.apply_shield(low_shield_value, battle_state.player_stats)
	battle_state.player_stats.shielded.emit()

func aoe_stun(battle_state: BattleState):
	for monster in battle_state.level_monsters:
		var status = StatusEffect.new(StatusUtils.status_effects.STUN)
		StatusUtils.apply_status_effects(monster, status)
		monster.statused.emit()

func aoe_vulnerable(battle_state: BattleState):
	for monster in battle_state.level_monsters:
		var status = StatusEffect.new(StatusUtils.status_effects.VULNERABLE, 3)
		StatusUtils.apply_status_effects(monster, status)
		monster.statused.emit()
