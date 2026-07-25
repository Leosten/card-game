class_name MonsterData
extends Resource

enum MonsterType {COMMON, MINIBOSS, BOSS}

@export var id = 0
@export var battle_position = 0
@export var name := ""
@export var type : MonsterType = MonsterType.COMMON 
@export var health := 0
@export var shield := 0
@export var status_effects := []
@export var action_cycle := []
@export var description := ""

# Called when the node enters the scene tree for the first time.
func _init(
	id = 0,
	battle_position = 0,
	name = "", 
	type = "", 
	health = 0,
	shield = 0,
	status_effects = [],
	action_cycle = [],
	description = ""
	):
	pass
