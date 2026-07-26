class_name StageManager
extends Node

const MonsterData = preload("res://Resources/Monsters/MonsterData.gd")

var stage_monsters : Array[MonsterData] = []
enum level_type {COMMON, MINIBOSS, BOSS, TREASURE, SPECIAL}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	var monster : PackedScene = load("res://BattleView/Monsters/"+ str(monster_id)+ "/monster_"+ str(monster_id)+ ".tscn")
	if monster == null:
		printerr("Cannot load monster scene %s" % str(monster_id))
		return
	return monster.instantiate()
	
func get_level_monsters(level) :
	match level:
		1:
			#return [[1],[1,1],[1,1,1]]
			return [[1,1,1,1,1,1]]
	return []
