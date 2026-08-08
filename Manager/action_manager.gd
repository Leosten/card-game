class_name ActionManager
extends Node

signal update_battle_state(battle_state : BattleState)
signal card_used(card_data : CardData)
signal action_impossible

func _ready() -> void:
	pass

func cost_card_mana(battle_state: BattleState, card_cost):
	battle_state.player_stats.current_mana -= card_cost
	battle_state.player_stats.current_mana_changed.emit()

func use_card_on_enemy(card : CardData, battle_state: BattleState, monster_data: MonsterData):
	if !card.allowed_targets.has(CardUtils.targets.ENEMY):
		print("ERROR : target not allowed")
	print("card used on monster %s" % str(monster_data.battle_position))
	if card.conditions_check(battle_state) == false:
		action_impossible.emit()
		return
	apply_card_action(battle_state, card, monster_data)

func use_card_on_ally(card : CardData, battle_state: BattleState):
	if card.allowed_targets.has(CardUtils.targets.ALLY) == false:
		if card.allowed_targets.has(CardUtils.targets.SELF) == false:
			print("ERROR : target not allowed")
			return
	if card.conditions_check(battle_state) == false:
		action_impossible.emit()
		return
	apply_card_action(battle_state, card)
	print("card used on ally")
	update_battle_state.emit(battle_state)

func apply_card_action(battle_state : BattleState, card : CardData, enemy : MonsterData = null):
	for action in card.actions:
		if action == CardUtils.action_type.HEAL:
			var heal_value = HealUtils.calculate_final_heal(card.heal, battle_state.player_stats)
			HealUtils.apply_heal(heal_value, battle_state.player_stats)
			battle_state.player_stats.healed.emit(heal_value)
		if action == CardUtils.action_type.SHIELD:
			var shield_value = HealUtils.calculate_final_shield(card.shield, battle_state.player_stats)
			HealUtils.apply_shield(shield_value, battle_state.player_stats)
			battle_state.player_stats.shielded.emit()
			battle_state.player_stats.stats_changed.emit()
		if action == CardUtils.action_type.BUFFS:
			StatusUtils.apply_buffs(battle_state.player_stats, card.buffs)

		# ELEMENTAL COMPANION
		if battle_state.companion_stats is ElementalCompanionStats:
			if action == CardUtils.action_type.CHANNEL_ADD:
				battle_state.companion_stats.channel_add(card)
			
			##CHECK WHEN ADDED allows for cards that add then remove
			#battle_state.companion_stats.check_orb_activation(battle_state)
			
			if action == CardUtils.action_type.CHANNEL_USE:
				battle_state.companion_stats.use_orb(card)
			if action == CardUtils.action_type.CHANNEL_REMOVE:
				battle_state.companion_stats.channel_remove(card)
			if action == CardUtils.action_type.CHANNEL_CLEAR:
				battle_state.companion_stats.reset_channel_orbs(card)

		# ON ENEMY
		if enemy != null :
			if action == CardUtils.action_type.DAMAGE:
				var final_damage = DamageUtils.calculate_final_damage(card.damage, battle_state.player_stats, enemy)
				DamageUtils.apply_damage(final_damage, enemy)
			if action == CardUtils.action_type.STATUS_EFFECTS:
				StatusUtils.apply_status_effects(enemy, card.status_effects)
			enemy.stats_changed.emit()
			check_for_death(enemy, battle_state)
	card.special_effect(battle_state)
	battle_state.player_stats.stats_changed.emit()
	cost_card_mana(battle_state, card.cost)
	card_used.emit(card)

func apply_enemy_action(battle_state: BattleState, action : MonsterAction, enemy : Targetable):
	enemy.acting.emit(action.type)
	if action.type == MonsterUtils.action_types.DAMAGE:
		var final_damage = DamageUtils.calculate_final_damage(action.damage, battle_state.player_stats, enemy)
		DamageUtils.apply_damage(final_damage, battle_state.player_stats)
	if action.type == MonsterUtils.action_types.DAMAGE_STATUS:
		var final_damage = DamageUtils.calculate_final_damage(action.damage, enemy, battle_state.player_stats)
		DamageUtils.apply_damage(final_damage, battle_state.player_stats)
		
	if action.type == MonsterUtils.action_types.SHIELD:
		var final_heal = HealUtils.calculate_final_shield(action.shield, enemy)
		HealUtils.apply_shield(final_heal, enemy)
	enemy.stats_changed.emit()

func enemy_cycle(battle_state : BattleState, enemy: MonsterData):
	var action = enemy.getAction()
	if (StatusUtils.action_possible(enemy) == true):
		apply_enemy_action(battle_state, action, enemy)
	cycle_statuses(enemy)
	enemy.cycle_step +=1
	enemy.reset_cycle_step()

func check_for_death(monster: MonsterData, battle_state : BattleState):
	if (monster.health <= 0):
		monster.health = 0
		battle_state.level_monsters.erase(monster)
		print("enemy %s dead" % monster.battle_position)

func use_card_on_all_enemies():
	pass

func cycle_statuses(target : Targetable):
	if not target.buffs.is_empty():
		for buff : Status in target.buffs:
			StatusUtils.check_for_status_cycle(target.buffs, buff)
	if not target.status_effects.is_empty():
		for status : Status in target.status_effects:
			StatusUtils.check_for_status_cycle(target.status_effects, status)
	target.stats_changed.emit()
