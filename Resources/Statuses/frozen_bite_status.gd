class_name FrozenBiteStatus

extends Status

var damage = 2

func _init(target : Targetable, initial_stacks : int, modified_damage : int = 0) -> void:
	super(target, initial_stacks)
	type = StatusUtils.names.FROZEN_BITE
	GameManager.battle_state.companion_stats.ice_channeled.connect(_on_ice_channeled)
	if modified_damage > 0 :
		damage = modified_damage

func _on_ice_channeled():
	var monsters = GameManager.battle_state.level_monsters
	for monster in monsters:
		print("monster ", monster.name, " attacked")
		var ice_damage = stacks * damage
		var final_damage = DamageUtils.calculate_final_damage(ice_damage, GameManager.battle_state.player_stats, monster)
		DamageUtils.apply_damage(final_damage, monster)

func clear():
	GameManager.battle_state.companion_stats.ice_channeled.disconnect(_on_ice_channeled)
