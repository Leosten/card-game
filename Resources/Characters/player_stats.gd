class_name PlayerStats

extends Resource

@export var health : int = 100
@export var mana : int = 5
@export var level_progression: int = 0
@export var stage_progression: int = 0
@export var char_id = 0
@export var buffs = StatusUtils.buffs
@export var status_effects = StatusUtils.status_effects


func _init(
	char_id = 0,
	health = 0,
	mana = 0,
	level_progression = 0, 
	stage_progression = 0
	):
		health = health
		mana = mana
		level_progression = level_progression
		stage_progression = stage_progression
