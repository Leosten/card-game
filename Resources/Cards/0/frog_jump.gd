extends CardData

func _init():
	#GameManager.battle_state.player_stats.companion_stats.channeled.connect(on_channeled)
	actions = [CardUtils.action_type.CHANNEL_SPECIAL]
	allowed_targets = [CardUtils.targets.ENEMY]

func use_special(battle_state: BattleState, enemy : Targetable = null):
	if enemy == null:
		return
	var companion_stats : ElementalCompanionStats = battle_state.player_stats.companion_stats
	if companion_stats.ice_count <= 0:
		return
	var damage = companion_stats.ice_count * self.damage
	var final_damage = DamageUtils.calculate_final_damage(damage, battle_state.player_stats, enemy)
	DamageUtils.apply_damage(final_damage, enemy)
