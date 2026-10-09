class_name StageManager
extends Node

enum level_type {COMMON, MINIBOSS, BOSS, TREASURE, SPECIAL, SHOP, FORGE, RANDOM}
var max_current_level = 10
var max_current_stage = 1

@export var current_level = 0;
@export var current_stage = 1;
@export var current_encounter_type: level_type

func _ready() -> void:
	pass
	#Events.next_encounter.connect(on_next_battle)

func get_random_encounter():
	var possible_encounters = [
		level_type.COMMON, 
		level_type.MINIBOSS,
		#level_type.TREASURE,
		level_type.SHOP,
		#level_type.FORGE,
	]
	
	GameManager.map_manager.current_node.encounter_type = possible_encounters.pick_random()

static func get_stage_encounter_types(level: int) -> Array[level_type]:
	match level:
		#0:
			#return [level_type.COMMON]
		#1:
			#return [level_type.SHOP]
		1:
			return [level_type.COMMON]
		2:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM]
		3:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM, level_type.SHOP]
		4:
			return [level_type.COMMON,level_type.MINIBOSS]
		5:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM]
		6:
			return [level_type.SHOP, level_type.FORGE]
		7:
			return [level_type.COMMON, level_type.COMMON, level_type.TREASURE]
		8:
			return [level_type.COMMON, level_type.MINIBOSS, level_type.RANDOM, level_type.SHOP]
		9:
			return [level_type.COMMON, level_type.TREASURE, level_type.RANDOM]
		10:
			return [level_type.COMMON, level_type.MINIBOSS, level_type.RANDOM,level_type.SHOP]
		11:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM]
		12:
			return [level_type.BOSS]
		_:
			return []

static func get_encounter_name_by_type(type : level_type):
	match type:
		level_type.COMMON:
			return "Encounter"
		level_type.MINIBOSS:
			return "Mini Boss"
		level_type.BOSS:
			return "Boss"
		level_type.TREASURE:
			return "Treasure"
		level_type.RANDOM:
			return "?"
		level_type.SHOP:
			return "Shop"
		level_type.FORGE:
			return "Forge"
		_:
			return ""

static func get_stage_possible_monsters(stage) :
	match stage:
		1:
			return ["umbrella","yokai", "fireball", "goblin", "byakko"]

func _get_stage_one_common_monsters(level) :
	match level:
		1:
			return [["goblin"]]
		2:
			return [["umbrella", "goblin","goblin","yokai"]]
		3:
			return [["umbrella","yokai"]]
		4:
			return [["goblin"],["fireball","umbrella"]]
		5:
			return [["umbrella"],["yokai","fireball"]]
		6:
			return [["umbrella"],["goblin","umbrella"]]
		7:
			return [["umbrella","yokai"],["goblin","umbrella"]]
		8:
			return [["umbrella","yokai"],["umbrella","umbrella","yokai"]]
		9:
			return [["umbrella","fireball"],["umbrella","umbrella","fireball"]]
		10:
			return [["fireball","goblin"],["umbrella","umbrella","fireball"]]
		11:
			return [["umbrella","goblin"],["umbrella","goblin","fireball"]]
		12:
			return [["goblin","goblin"],["umbrella","umbrella","goblin"]]
	return []

func _get_stage_one_miniboss(level) :
	return [["umbrella","umbrella","umbrella"]]

func get_monsters_by_encounter_type():
	match current_stage:
		1:
			if current_encounter_type == level_type.COMMON:
				return _get_stage_one_common_monsters(current_level).pick_random()
			if current_encounter_type == level_type.MINIBOSS:
				return _get_stage_one_miniboss(current_level).pick_random()
			if current_encounter_type == level_type.BOSS:
				return _get_boss_by_stage(current_stage)
		_:
			return null

func _get_boss_by_stage(curr_stage: int):
	match(curr_stage):
		1:
			return ["byakko"]
		_:
			printerr("stage boss not found")
			return

func encounter_progress():
	if current_stage == max_current_stage and current_level == max_current_level:
		Events.game_completed.emit()
		print("game completed")
		return
	if current_level == max_current_level:
		current_level = 1
		max_current_stage +=1
		print("stage completed")
		return
	print("level progress")
	current_level += 1
