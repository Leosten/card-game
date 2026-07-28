class_name ActionManager
extends Node

signal update_battle_view

signal card_used(card_data : CardData)
signal mana_used(cost : int)
signal enemy_hit(monster : MonsterData)
signal enemy_attacking(monster : MonsterData)

func _ready() -> void:
	pass

func cost_card_mana(battle_state: BattleState, card_cost) -> BattleState:
	battle_state.player_stats.current_mana -= card_cost
	mana_used.emit(card_cost)
	return battle_state

func use_card_on_enemy(card : CardData, battle_state: BattleState, monster_data: MonsterData):
	if !card.allowed_targets.has(CardUtils.targets.ENEMY):
		print("ERROR : target not allowed")
		return battle_state
	print("card used on monster %s" % str(monster_data.battle_position))
	
	battle_state = apply_card_action(battle_state, card, monster_data)

	return battle_state

func use_card_on_ally(card : CardData, battle_state: BattleState):
	if card.allowed_targets.has(CardUtils.targets.ALLY) == false:
		if card.allowed_targets.has(CardUtils.targets.SELF) == false:
			print("ERROR : target not allowed")
			return battle_state
	battle_state = apply_card_action(battle_state, card)
	print("card used on ally")
	
	update_battle_view.emit()
	return battle_state

func apply_card_action(battle_state : BattleState, card : CardData, enemy : MonsterData = null):
	for action in card.actions:
		if action == CardUtils.action_type.HEAL:
			var heal_value = HealUtils.calculate_ally_final_heal(card.heal, battle_state.player_stats)
			battle_state.player_stats = HealUtils.apply_ally_heal(heal_value, battle_state.player_stats)
		if action == CardUtils.action_type.SHIELD:
			var shield_value = HealUtils.calculate_ally_final_shield(card.shield, battle_state.player_stats)
			battle_state.player_stats = HealUtils.apply_ally_shield(shield_value, battle_state.player_stats)
		if action == CardUtils.action_type.BUFFS:
			battle_state.player_stats.buffs = StatusUtils.apply_buffs(battle_state.player_stats.buffs, card.buffs)
		if (enemy != null) :
			if action == CardUtils.action_type.DAMAGE:
				print("card attack type")
				var final_damage = DamageUtils.calculate_ally_final_damage(card.damage, battle_state.player_stats, enemy)
				enemy = DamageUtils.damage_enemy(final_damage, enemy)
			if action == CardUtils.action_type.STATUS_EFFECTS:
				print("card status type")
				enemy.status_effects = StatusUtils.apply_status_effects(enemy.status_effects, card.status_effects)
			battle_state = check_for_death(enemy, battle_state)
			
	battle_state = cost_card_mana(battle_state, card.cost)
	card_used.emit(card)
	mana_used.emit()
	update_battle_view.emit()
	return battle_state

func apply_enemy_action(battle_state: BattleState, action : MonsterAction, enemy : MonsterData):
	if (action.type == MonsterUtils.action_types.DAMAGE):
		var final_damage = DamageUtils.calculate_enemy_final_damage(action.damage, battle_state.player_stats, enemy)
		battle_state.player_stats = DamageUtils.damage_player(final_damage, battle_state.player_stats)
	if (action.type == MonsterUtils.action_types.DAMAGE_STATUS):
		var final_damage = DamageUtils.calculate_enemy_final_damage(action.damage, battle_state.player_stats, enemy)
	return battle_state
	
func enemy_cycle(battle_state : BattleState, enemy: MonsterData) -> BattleState:
	var action = enemy.getAction()
	
	battle_state = apply_enemy_action(battle_state, action, enemy)
	
	enemy.cycle_step +=1
	enemy.reset_cycle_step()
	return battle_state

static func check_for_death(monster: MonsterData, battle_state : BattleState) -> BattleState:
	if (monster.health <= 0):
		monster.health = 0
		print("enemy %s dead" % monster.battle_position)
		battle_state.level_monsters.erase(monster)
	else:
		battle_state = MonsterUtils.update_monster(battle_state, monster)
	return battle_state
	
func cycle_buffs():
	pass

func use_card_on_all_enemies():
	pass
