class_name ActionManager
extends Node

signal update_battle_state(battle_state : BattleState)
signal card_used(card_data : CardData)
signal draw_cards(nb : int)
signal action_impossible

var battle_state: BattleState
var monster_manager : MonsterManager

func _init() -> void:
	battle_state = GameManager.battle_state
	monster_manager = GameManager.monster_manager
	Events.turn_start.connect(start_turn_status_cycle)
	Events.turn_end.connect(end_turn_status_cycle)

func cost_card_mana(card_cost):
	battle_state.player_stats.current_mana -= card_cost
	battle_state.player_stats.current_mana_changed.emit()

func use_card_on_grid(clicked_cell : Vector2i, card : CardData):
	var targets = GameManager.grid_manager.get_affected_targets(clicked_cell, card)
	for target : TargetCharacter in targets:
		if card.grid_target == CardUtils.grid_target.ENEMY:
			if target.stats is MonsterData:
				use_card_on_enemy(card, target.stats)

func use_card_on_enemy(card : CardData, monster_data: MonsterData):
	if !card.allowed_targets.has(CardUtils.targets.ENEMY):
		print("ERROR : target not allowed")
	print("card used on monster %s" % str(monster_data.battle_position))
	apply_card_action(card, monster_data)

func use_card_on_ally(card : CardData):
	if card.allowed_targets.has(CardUtils.targets.ALLY) == false:
		if card.allowed_targets.has(CardUtils.targets.SELF) == false:
			print("ERROR : target not allowed")
			return
	apply_card_action(card)
	print("card used on ally")
	update_battle_state.emit(battle_state)

func apply_card_action(card : CardData, enemy : MonsterData = null):
	if card.conditions_check(battle_state) == false:
		print("Card conditions not met")
		action_impossible.emit()
		return
	for action in card.actions:
		card_apply_buff_action(card, action)
		card_elemental_companion_action(card, action)
		
		var enemies = []
		if (card.allowed_targets.has(CardUtils.targets.ALL_ENEMIES)):
			enemies = monster_manager.level_monsters
		else:
			if enemy != null :
				enemies = [enemy]
		
		for target in enemies:
			card_apply_damage_action(card, action, target)
			card.use_special(battle_state, enemy)
			target.stats_changed.emit()
			# TODO: enemy dies and action continues ...
	check_for_everyone_death()
	card.use_special(battle_state)
	battle_state.player_stats.stats_changed.emit()
	cost_card_mana(card.cost)
	send_card_used_signal(card)

func send_card_used_signal(card: CardData):
	if card.exhaust == true:
		card.exhausted.emit()
	else:
		card.used.emit()

func card_apply_damage_action(card: CardData, action: CardUtils.action_type, enemy: Targetable):
	if action == CardUtils.action_type.DAMAGE:
		var final_damage = DamageUtils.calculate_final_damage(card.damage, battle_state.player_stats, enemy)
		DamageUtils.apply_damage(final_damage, enemy)
	if action == CardUtils.action_type.STATUS_EFFECTS:
		enemy.status_manager.apply_status(card.status_effects)

func card_apply_buff_action(card: CardData, action: CardUtils.action_type):
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
		battle_state.player_stats.status_manager.apply_status(card.buffs)
	if action == CardUtils.action_type.DRAW:
		battle_state.draw_cards.emit(card.draw_value)

func card_elemental_companion_action(card: CardData, action: CardUtils.action_type):
	if battle_state.companion_stats is not ElementalCompanionStats:
		return
	if action == CardUtils.action_type.CHANNEL_ADD:
		battle_state.companion_stats.channel_add(card)
	if action == CardUtils.action_type.CHANNEL_USE:
		battle_state.companion_stats.use_orb(battle_state, card.channel_remove_value)
	if action == CardUtils.action_type.CHANNEL_REMOVE:
		battle_state.companion_stats.channel_remove(card)
	if action == CardUtils.action_type.CHANNEL_CLEAR:
		battle_state.companion_stats.reset_channel_orbs(card)
	if action == CardUtils.action_type.CHANNEL_SPECIAL:
		battle_state.companion_stats.channel_special(card, battle_state)
		#card.use_special(battle_state, null)

func apply_enemy_action(action : MonsterAction, enemy : Targetable):
	enemy.acting.emit(action.type)
	if action.type == MonsterUtils.action_types.DAMAGE:
		var final_damage = DamageUtils.calculate_final_damage(action.damage, battle_state.player_stats, enemy)
		DamageUtils.apply_damage(final_damage, battle_state.player_stats)
	if action.type == MonsterUtils.action_types.DAMAGE_STATUS:
		var final_damage = DamageUtils.calculate_final_damage(action.damage, enemy, battle_state.player_stats)
		DamageUtils.apply_damage(final_damage, battle_state.player_stats)
		battle_state.player_stats.status_manager.apply_status(action.status_effects)
	if action.type == MonsterUtils.action_types.SHIELD:
		var final_heal = HealUtils.calculate_final_shield(action.shield, enemy)
		HealUtils.apply_shield(final_heal, enemy)
	if action.type == MonsterUtils.action_types.BUFF:
		enemy.status_manager.apply_status(action.buffs)
	enemy.stats_changed.emit()

func enemy_cycle(enemy: MonsterData):
	var action = enemy.get_action()
	if StatusUtils.action_possible(enemy) == true:
		apply_enemy_action(action, enemy)
	print("enemy cycle :", str(enemy.cycle_step))
	enemy.cycle_step +=1
	enemy.reset_cycle_step()

func check_for_death(monster: MonsterData):
	if (monster.health <= 0):
		monster.health = 0
		print("enemy %s dead" % monster.battle_position)
	return true

func check_for_everyone_death():
	for monster in  monster_manager.level_monsters:
		check_for_death(monster)

func end_turn_status_cycle():
	for monster in  monster_manager.level_monsters:
		monster.status_manager.trigger_turn_end()
	battle_state.player_stats.status_manager.trigger_turn_end()
	print("TURN END")

func start_turn_status_cycle():
	for monster in  monster_manager.level_monsters:
		monster.status_manager.trigger_turn_start()
	battle_state.player_stats.status_manager.trigger_turn_start()
	print("TURN START")
