class_name ElementalCompanionStats

extends CompanionStats

signal channeled
signal cycled
signal channel_used
signal channel_high_trigger
signal channel_removed(nb)
signal channel_reset
signal channel_special_used
signal use_ceiling_not_reached
signal ice_channeled

@export var channel_orbs : Array[CardUtils.magic_type]= []
@export var max_channel_orbs = 5
@export var channel_high_activation_ceiling = 5
@export var channel_low_activation_ceiling = 3
@export var companion_type = CompanionUtils.companion_type.ELEMENTAL
@export var fire_high_damage = 25
@export var fire_low_damage = 15
@export var big_shield_value = 30
@export var low_shield_value = 15
@export var fire_count = 0
@export var ice_count = 0
@export var wind_count = 0

func channel_add(card : CardData):
	var orbs : Array[CardUtils.magic_type] = card.channel_add()
	add_orbs(orbs)
	
func add_orbs(orbs : Array[CardUtils.magic_type]):
	for orb : CardUtils.magic_type in orbs:
		if channel_orbs.size() == max_channel_orbs and check_activation_ceiling() == false :
			channel_orbs.pop_back()
			channel_orbs.push_front(orb)
			_add_count(orb)
			cycled.emit()
			if check_activation_ceiling():
				trigger_high()
			continue
		channel_orbs.append(orb)
		channeled.emit()
		_add_count(orb)
		if check_activation_ceiling():
			trigger_high()
			

func _add_count(orb_type : CardUtils.magic_type):
	add_count(orb_type)
	
	if (orb_type == CardUtils.magic_type.ICE):
		ice_channeled.emit()
	
	channeled.emit()

func channel_remove(card : CardData):
	channel_orbs = card.channel_remove(channel_orbs)
	channel_removed.emit()

func channel_special(card : CardData, battle_state : BattleState):
	#channel_orbs = card.special_effect(battle_state)
	channel_special_used.emit()

func reset_channel_orbs():
	channel_orbs.clear()
	channel_reset.emit()
	#reset_count()

func add_count(orb : CardUtils.magic_type):
	if orb == CardUtils.magic_type.FIRE:
		fire_count += 1
	if orb == CardUtils.magic_type.ICE:
		ice_count += 1
	if orb == CardUtils.magic_type.WIND:
		wind_count += 1

func reset_count():
	fire_count = 0
	ice_count = 0
	wind_count = 0
	for orb in channel_orbs:
		if orb == CardUtils.magic_type.FIRE:
			fire_count += 1
		if orb == CardUtils.magic_type.ICE:
			ice_count += 1
		if orb == CardUtils.magic_type.WIND:
			wind_count += 1

func check_activation_ceiling() -> bool:
	if channel_orbs.count(CardUtils.magic_type.FIRE) >= channel_high_activation_ceiling:
		return true
	if channel_orbs.count(CardUtils.magic_type.ICE) >= channel_high_activation_ceiling:
		return true
	if channel_orbs.count(CardUtils.magic_type.WIND) >= channel_high_activation_ceiling:
		return true
	return false

func check_low_activation_ceiling():
	if channel_orbs.count(CardUtils.magic_type.FIRE) >= channel_low_activation_ceiling:
		return true
	if channel_orbs.count(CardUtils.magic_type.ICE) >= channel_low_activation_ceiling:
		return true
	if channel_orbs.count(CardUtils.magic_type.WIND) >= channel_low_activation_ceiling:
		return true
	use_ceiling_not_reached.emit()
	return false

# level 5 action
func trigger_high():
	if GameManager.battle_state.level_monsters.is_empty():
		return
	var battle_state = GameManager.get_battle_state()
	if channel_orbs.count(CardUtils.magic_type.FIRE) >= channel_high_activation_ceiling:
		explosion(battle_state)
	if channel_orbs.count(CardUtils.magic_type.ICE) >= channel_high_activation_ceiling:
		big_shield(battle_state)
	if channel_orbs.count(CardUtils.magic_type.WIND) >= channel_high_activation_ceiling:
		aoe_stun(battle_state)
	channel_high_trigger.emit()
	reset_channel_orbs()

# level 3 action
func use_orb(battle_state : BattleState):
	print("use orb lvl 3 check")
	if channel_orbs.count(CardUtils.magic_type.FIRE) >= channel_low_activation_ceiling:
		aoe_explosion(battle_state)
		channel_orbs = CompanionUtils.remove_orb_by_type(channel_orbs, CardUtils.magic_type.FIRE, channel_low_activation_ceiling)
	if channel_orbs.count(CardUtils.magic_type.ICE) >= channel_low_activation_ceiling:
		small_shield(battle_state)
		channel_orbs = CompanionUtils.remove_orb_by_type(channel_orbs, CardUtils.magic_type.ICE, channel_low_activation_ceiling)
	if channel_orbs.count(CardUtils.magic_type.WIND) >= channel_low_activation_ceiling:
		aoe_vulnerable(battle_state)
		channel_orbs = CompanionUtils.remove_orb_by_type(channel_orbs, CardUtils.magic_type.WIND, channel_low_activation_ceiling)
	#reset_count()
	channel_used.emit()
	channel_removed.emit()

func explosion(battle_state: BattleState):
	print("explosion triggered !")
	var enemy = battle_state.level_monsters.pick_random()
	DamageUtils.apply_damage(fire_high_damage, enemy)
	enemy.damage_taken.emit()

func aoe_explosion(battle_state: BattleState):
	print("aoe explosion triggered !")
	for monster in battle_state.level_monsters:
		DamageUtils.apply_damage(fire_low_damage, monster)
		monster.damage_taken.emit()

func big_shield(battle_state: BattleState):
	print("big shield triggered !")
	HealUtils.apply_shield(big_shield_value, battle_state.player_stats)
	battle_state.player_stats.shielded.emit()

func small_shield(battle_state: BattleState):
	print("small shield triggered !")
	HealUtils.apply_shield(low_shield_value, battle_state.player_stats)
	battle_state.player_stats.shielded.emit()

func aoe_stun(battle_state: BattleState):
	print("aoe_stun triggered !")
	for monster in battle_state.level_monsters:
		var status = CardStatus.new(StatusUtils.names.STUN, 0)
		monster.status_manager.apply_status([status])
		monster.statused.emit()

func aoe_vulnerable(battle_state: BattleState):
	print("aoe_vulnerable triggered !")
	for monster in battle_state.level_monsters:
		var status = CardStatus.new(StatusUtils.names.VULNERABLE, 2)
		monster.status_manager.apply_status([status])
		monster.statused.emit()

func cleanup_fight():
	channel_orbs.clear()
	reset_count()
	channel_reset.emit()
