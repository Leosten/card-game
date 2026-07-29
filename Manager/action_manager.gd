class_name ActionManager
extends Node

signal update_battle_state(battle_state : BattleState)

signal card_used(card_data : CardData)

func _ready() -> void:
	pass

func cost_card_mana(battle_state: BattleState, card_cost):
	battle_state.player_stats.current_mana -= card_cost
	battle_state.player_stats.current_mana_changed.emit(card_cost)

func use_card_on_enemy(card : CardData, battle_state: BattleState, monster_data: MonsterData):
	if !card.allowed_targets.has(CardUtils.targets.ENEMY):
		print("ERROR : target not allowed")
	print("card used on monster %s" % str(monster_data.battle_position))
	
	apply_card_action(battle_state, card, monster_data)

func use_card_on_ally(card : CardData, battle_state: BattleState):
	if card.allowed_targets.has(CardUtils.targets.ALLY) == false:
		if card.allowed_targets.has(CardUtils.targets.SELF) == false:
			print("ERROR : target not allowed")
			return
	apply_card_action(battle_state, card)
	print("card used on ally")
	update_battle_state.emit(battle_state)

func apply_card_action(battle_state : BattleState, card : CardData, enemy : MonsterData = null):
	for action in card.actions:
		if action == CardUtils.action_type.HEAL:
			var heal_value = HealUtils.calculate_final_heal(card.heal, battle_state.player_stats)
			battle_state.player_stats = HealUtils.apply_heal(heal_value, battle_state.player_stats)
			battle_state.player_stats.healed.emit(heal_value)
		if action == CardUtils.action_type.SHIELD:
			var shield_value = HealUtils.calculate_final_shield(card.shield, battle_state.player_stats)
			battle_state.player_stats = HealUtils.apply_shield(shield_value, battle_state.player_stats)
			battle_state.player_stats.shielded.emit(shield_value)
		if action == CardUtils.action_type.BUFFS:
			battle_state.player_stats = StatusUtils.apply_buffs(battle_state.player_stats, card.buffs)
		if (enemy != null) :
			if action == CardUtils.action_type.DAMAGE:
				print("card attack type")
				var final_damage = DamageUtils.calculate_final_damage(card.damage, battle_state.player_stats, enemy)
				enemy = DamageUtils.apply_damage(final_damage, enemy)
			if action == CardUtils.action_type.STATUS_EFFECTS:
				print("card status type")
				enemy = StatusUtils.apply_status_effects(enemy, card.status_effects)
			check_for_death(enemy, battle_state)

	cost_card_mana(battle_state, card.cost)
	card_used.emit(card)

func apply_enemy_action(battle_state: BattleState, action : MonsterAction, enemy : MonsterData):
	enemy.acting.emit(action.type)
	if (action.type == MonsterUtils.action_types.DAMAGE):
		var final_damage = DamageUtils.calculate_final_damage(action.damage, battle_state.player_stats, enemy)
		battle_state.player_stats = DamageUtils.apply_damage(final_damage, battle_state.player_stats)
	if (action.type == MonsterUtils.action_types.DAMAGE_STATUS):
		var final_damage = DamageUtils.calculate_final_damage(action.damage, enemy, battle_state.player_stats)
	
func enemy_cycle(battle_state : BattleState, enemy: MonsterData):
	var action = enemy.getAction()
	
	apply_enemy_action(battle_state, action, enemy)
	
	enemy.cycle_step +=1
	enemy.reset_cycle_step()

func check_for_death(monster: MonsterData, battle_state : BattleState):
	if (monster.health <= 0):
		monster.health = 0
		battle_state.level_monsters.erase(monster)
		print("enemy %s dead" % monster.battle_position)
func use_card_on_all_enemies():
	pass
