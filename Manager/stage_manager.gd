class_name StageManager
extends Node

var stage_monsters : Array[MonsterData] = []
enum level_type {COMMON, MINIBOSS, BOSS, TREASURE, SPECIAL, SHOP, FORGE, RANDOM}
var max_current_level = 10
var max_current_stage = 1

# positioning variables
var max_nb_of_enemies = 6
var max_nb_of_enemies_per_row = 3
var battle_line_margin = 900
var enemy_first_row = 420
var enemy_first_column = 300
var enemy_column_margin = 350
var row_margin = 320

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
		#level_type.SHOP, 
		#level_type.FORGE,
	]
	
	GameManager.map_manager.current_node.encounter_type = possible_encounters.pick_random()

static func get_stage_encounter_types(level: int) -> Array[level_type]:
	match level:
		#0:
			#return [level_type.COMMON]
		1:
			return [level_type.SHOP]
		#1:
			#return [level_type.COMMON]
		2:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM]
		3:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM]
		4:
			return [level_type.COMMON,level_type.MINIBOSS]
		5:
			return [level_type.COMMON, level_type.COMMON, level_type.RANDOM]
		6:
			return [level_type.SHOP, level_type.FORGE]
		7:
			return [level_type.COMMON, level_type.COMMON, level_type.TREASURE]
		8:
			return [level_type.COMMON, level_type.MINIBOSS, level_type.RANDOM]
		9:
			return [level_type.COMMON, level_type.TREASURE, level_type.RANDOM]
		10:
			return [level_type.COMMON, level_type.MINIBOSS, level_type.RANDOM]
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

func get_stage_possible_monsters(stage) :
	match stage:
		1:
			return ["umbrella","yokai", "fireball", "goblin", "byakko"]

func get_stage_monsters():
	var monster_names = get_stage_possible_monsters(current_stage)
	for name in monster_names:
		var monster = load("res://Resources/Monsters/" + name + "/" + name + ".tres")
		if monster == null:
			printerr("Cannot load monster data ressource %s" % name)
			return
		stage_monsters.append(monster.duplicate(true))
		print("stage monsters loaded")
	return stage_monsters

func get_monster_scene_from_name(monster_name):
	var monster : PackedScene = load("res://View/Monsters/" + monster_name+ "/" + monster_name + ".tscn")
	if monster == null:
		printerr("Cannot load monster scene %s" % monster_name)
		return
	return monster.instantiate()

func get_stage_one_common_monsters(level) :
	match level:
		1:
			return [["fireball"],["fireball"]]
		2:
			return [["umbrella", "goblin"],["yokai","fireball"]]
		3:
			return [["umbrella","yokai"]]
		4:
			return [["umbrella"],["fireball","umbrella"]]
		5:
			return [["umbrella"],["umbrella","fireball"]]
		6:
			return [["umbrella"],["umbrella","umbrella"]]
		7:
			return [["umbrella","yokai"],["umbrella","umbrella"]]
		8:
			return [["umbrella","umbrella"],["umbrella","umbrella","yokai"]]
		9:
			return [["umbrella","umbrella"],["umbrella","umbrella","fireball"]]
	return []

func get_stage_one_miniboss(level) :
	return [["umbrella","umbrella","umbrella"]]

func get_monsters_by_encounter_type():
	match current_stage:
		1:
			if current_encounter_type == level_type.COMMON:
				return get_stage_one_common_monsters(current_level).pick_random()
			if current_encounter_type == level_type.MINIBOSS:
				return get_stage_one_miniboss(current_level).pick_random()
			if current_encounter_type == level_type.BOSS:
				return get_boss_by_stage(current_stage)
		_:
			return null

func get_boss_by_stage(curr_stage: int):
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

func get_level_monsters() -> Array[MonsterData]:
	var monsters = get_monsters_by_encounter_type()
	
	var monster_index = 0
	var level_monsters : Array[MonsterData] = []
	for monster_name in monsters:
			for monster_data : MonsterData in stage_monsters:
				if monster_data.name == monster_name:
					var monster_d = monster_data.duplicate(true)
					monster_d.battle_position = monster_index
					level_monsters.append(monster_d)
			monster_index += 1
	print("get level monsters")
	return level_monsters

func get_monster_scenes_for_level(level_monsters, enemy_positions) -> Array[Monster]:
	var monster_scenes : Array[Monster] = []
	var index = 0

	for monster_data in level_monsters:
		var monster_scene = get_monster_scene_from_name(monster_data.name)
		print("get_monster_scenes_for_level")
		monster_scene.init_data(monster_data)
		monster_scene.battle_position = index
		monster_scene.position = enemy_positions[index].position
		# position monster outside of screen for animation
		monster_scene.position.x = 6000
		monster_scene.z_index = 100
		monster_scenes.append(monster_scene)
		index += 1
	return monster_scenes
	
func init_monster_positions(viewport_size) -> Array[Area2D]:
	var column_pos = 0
	var row_nb = 0
	var enemy_row_position = enemy_first_row
	var enemy_column_position = enemy_first_column
	var enemy_positions : Array[Area2D] = []
	
	for monster_pos_index in max_nb_of_enemies:
		var monster_area = Area2D.new()
		if (column_pos == max_nb_of_enemies_per_row) :
			column_pos = 0
			row_nb += 1
			enemy_column_position += enemy_column_margin / 2
		var monster_position := Vector2(
			viewport_size.x - (enemy_column_position + (column_pos * enemy_column_margin)),
			viewport_size.y - (enemy_row_position + (row_margin * row_nb))
		)
		column_pos += 1
		monster_area.position = monster_position
		enemy_positions.append(monster_area)
	return enemy_positions
