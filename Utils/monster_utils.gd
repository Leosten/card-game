class_name MonsterUtils

extends Node

static func updateMonsterByPosition(
	battle_state : Dictionary,
	monster_updated_data : MonsterData, 
	monster_position):
	for monster in battle_state["level_monsters"]:
		if monster.battle_position == monster_position:
			monster = monster_updated_data
			break
	return battle_state

static func findMonsterByPosition(
	battle_state : Dictionary,
	monster_position):
	for monster in battle_state["level_monsters"]:
		if monster.battle_position == monster_position:
			return monster
	printerr("monster with position %s not found" % str(monster_position))

static func removeMonsterDeadDisplay(monsters_displayed, dead_monster : MonsterData):
	var index = 0
	for monster_scene in monsters_displayed:
		if monster_scene.monster_data.battle_position == dead_monster.battle_position:
			monster_scene.die()
			monster_scene.queue_free()
			monsters_displayed.remove_at(index)
			break
		index +=1
	return monsters_displayed
