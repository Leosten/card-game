class_name MonsterUtils

extends Node

static func update_monster_by_position(
	battle_state : Dictionary,
	monster_updated_data : MonsterData, 
	monster_position):
	for monster in battle_state["level_monsters"]:
		if monster.battle_position == monster_position:
			monster = monster_updated_data
			break
	return battle_state

static func find_monster_by_position(
	battle_state : Dictionary,
	monster_position):
	for monster in battle_state["level_monsters"]:
		if monster.battle_position == monster_position:
			return monster
	printerr("monster with position %s not found" % str(monster_position))

static func remove_monster_dead_display(monsters_displayed, dead_monster : MonsterData):
	var index = 0
	for monster_scene in monsters_displayed:
		if monster_scene.monster_data.battle_position == dead_monster.battle_position:
			monsters_displayed.remove_at(index)
			break
		index +=1
	return monsters_displayed

static func update_level_monsters(monsters_displayed : Array[Monster], battle_state : Dictionary):
	for monster_scene in monsters_displayed:
		for monster_data in battle_state["level_monsters"]:
			if monster_scene.monster_data.battle_position == monster_data.battle_position:
				monster_scene.update_monster_state(monster_data)
	return monsters_displayed
