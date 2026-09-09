class_name MonsterData

extends Targetable

enum MonsterType {COMMON, MINIBOSS, BOSS}

@export var id = 0
@export var battle_position = 0
@export var name := ""
@export var display_name := ""
@export var type : MonsterType = MonsterType.COMMON 
@export var action_cycle : Array[MonsterAction] = []
@export var cycle_step = 0
@export var description := ""
@export var starting_column = 0
var buffs: Array[CardStatus] = []
var status : Array[CardStatus] = []

@export var gold = 0

func reset_cycle_step():
	if cycle_step == action_cycle.size():
		cycle_step = 0

func get_next_step():
	var next_cycle = 0
	if cycle_step == action_cycle.size():
		next_cycle = 0
	return next_cycle

func getAction():
	return action_cycle[cycle_step]
