extends MonsterData


func _init():
	action_cycle = [&"attack"]
	print('cycle set')

func attack(battle_state: Dictionary) -> Dictionary:
	var damage_value = 5
	damage_value = DamageUtils.calculate_enemy_final_damage(
		damage_value, 
		battle_state["player_stats"],
		self)
	battle_state["player_stats"] = DamageUtils.damage_player(damage_value, battle_state["player_stats"])
	print("enemy %s used attack" % battle_position)
	print("for %s" % damage_value)
	
	return battle_state

func defend():
	print("defense skill monster")
	pass
