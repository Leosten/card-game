class_name StageManager
extends Node

const MonsterData = preload("res://Resources/Monsters/monster_data.gd")

var stage_monsters : Array[MonsterData] = []
enum level_type {COMMON, MINIBOSS, BOSS, TREASURE, SPECIAL}

# positioning variables
var max_nb_of_enemies = 6
var max_nb_of_enemies_per_row = 3
var battle_line_margin = 900
var enemy_first_row = 420
var enemy_first_column = 300
var enemy_column_margin = 350
var row_margin = 320

func _ready() -> void:
	pass

func get_stage_possible_type(stage) :
	match stage:
		1:
			return [level_type.COMMON]
		2:
			return [level_type.COMMON]
		3:
			return [level_type.COMMON, level_type.MINIBOSS, level_type.TREASURE]
		4:
			return [level_type.COMMON, level_type.TREASURE, level_type.SPECIAL]
		5:
			return [level_type.BOSS]

func get_stage_possible_monsters(stage) :
	match stage:
		1:
			return [1]

func get_stage_monsters(stage_id):
	var monsters_id = get_stage_possible_monsters(stage_id)
	for monster_id in monsters_id:
		var monster = load("res://Resources/Monsters/"+ str(monster_id)+ "/monster_"+ str(monster_id)+ ".tres")
		if monster == null:
			printerr("Cannot load monster data ressource %s" % str(monster_id))
			return
		stage_monsters.append(monster.duplicate())	
	return stage_monsters

func get_monster_scene_from_id(monster_id):
	var monster : PackedScene = load("res://View/Monsters/"+ str(monster_id)+ "/monster_"+ str(monster_id)+ ".tscn")
	if monster == null:
		printerr("Cannot load monster scene %s" % str(monster_id))
		return
	return monster.instantiate()
	
func get_encounter_monsters(level) :
	match level:
		1:
			#return [[1],[1,1],[1,1,1]]
			#return [[1,1,1]]
			return [[1,1,1]]
	return []
	
func get_level_monsters(level) -> Array[MonsterData]:
	var possible_monsters = get_encounter_monsters(level)
	possible_monsters.shuffle()
	
	var monster_index = 0
	var level_monsters : Array[MonsterData] = []
	for monster_id in possible_monsters[0]:
			for monster_data : MonsterData in stage_monsters:
				if monster_data.id == monster_id:
					var monster_d = monster_data.duplicate()
					monster_d.battle_position = monster_index
					level_monsters.append(monster_d)
			monster_index += 1
	print("loaded level monsters")
	return level_monsters

func get_monster_scenes_for_level(level_monsters, enemy_positions) -> Array[Monster]:
	var monster_scenes : Array[Monster] = []
	var index = 0

	for monster_data in level_monsters:
		var monster_scene = get_monster_scene_from_id(monster_data.id)
		print("get_monster_scenes_for_level")
		monster_scene.init_data(monster_data.duplicate())
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
	print("Monster positions initiated")
