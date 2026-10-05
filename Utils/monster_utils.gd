class_name MonsterUtils

enum action_types {
	DAMAGE, 
	DAMAGE_STATUS, 
	STATUS, 
	SHIELD, 
	HEAL_SELF, 
	HEAL_OTHERS, 
	BUFF, 
	BUFF_OTHERS, 
	HEAVY_DAMAGE,
	MOVE_RANDOMLY,
	MOVE_TARGET,
	PUSH,
	PULL
}

static func remove_monster_dead_display(monsters_displayed, dead_monster : MonsterData):
	var index = 0
	for monster_scene in monsters_displayed:
		if monster_scene.monster_data == dead_monster:
			monsters_displayed.remove_at(index)
			break
		index +=1
	return monsters_displayed

static func update_level_monsters(monsters_displayed : Array[Monster], battle_state : BattleState) -> Array[Monster]:
	for monster_scene in monsters_displayed:
		for monster_data in battle_state.level_monsters:
			if monster_scene.monster_data == monster_data:
				monster_scene.update_monster_state(monster_data)
	return monsters_displayed
