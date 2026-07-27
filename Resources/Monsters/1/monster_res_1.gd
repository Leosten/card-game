extends MonsterData

func _ready():
	action_cycle = [attack, defend]

func attack(battle_state):
	var damage_value = 5
	battle_state = DamageUtils.calculate_enemy_final_damage(
		damage_value, 
		battle_state["player_stats"],
		self)
	return battle_state
	
func defend():
	pass
