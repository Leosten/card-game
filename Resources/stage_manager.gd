class_name StageManager
extends Node

const MonsterData = preload("res://Resources/Monsters/Data/MonsterData.gd")

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

func get_level_possible_monsters(level) :
	match level:
		1:
			return [1]

func load_stage_monsters(monsters_id:Array):
	for monster_id in monsters_id:
		var monster = load("res://Resources/Monsters/Data/"+ str(monster_id)+ ".tres")
		stage_monsters.append(monster.duplicate())	

func get_level_monsters(level):
	# shuffle stage monsters for level
	pass
