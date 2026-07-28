class_name MonsterData

extends Resource

enum MonsterType {COMMON, MINIBOSS, BOSS}

@export var id = 0
@export var battle_position = 0
@export var name := ""
@export var type : MonsterType = MonsterType.COMMON 
@export var health := 0
@export var max_health := 0
@export var shield := 0
@export var status_effects : Array[StatusEffect] = []
@export var buffs : Array[Buff] = []
@export var action_cycle : Array[MonsterAction] = []
@export var cycle_step = 0
@export var description := ""

func _init():
	pass

func reset_cycle_step():
	if cycle_step == action_cycle.size():
		cycle_step = 0

func getAction():
	return action_cycle[cycle_step]
