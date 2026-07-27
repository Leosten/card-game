class_name PlayerStats

extends Resource

@export var health : int = 0
@export var max_health : int = 0
@export var shield : int = 0
@export var mana : int = 5
@export var level_progression: int = 0
@export var stage_progression: int = 0
@export var char_id = 0
@export var buffs = StatusUtils.buffs
@export var status_effects = StatusUtils.status_effects

func _init():
	pass
