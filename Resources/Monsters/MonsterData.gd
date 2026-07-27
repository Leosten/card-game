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
@export var status_effects := StatusUtils.status_effects
@export var buffs := StatusUtils.buffs
@export var action_cycle := []
@export var cycle_step = 0
@export var description := ""

func _init(
	id = 0,
	battle_position = 0,
	name = "", 
	type = "", 
	health = 0,
	max_health = 0,
	shield = 0,
	status_effects = StatusUtils.status_effects,
	buffs = StatusUtils.buffs,
	action_cycle = [],
	cycle_step = 0,
	description = ""
	):
	pass

func reset_cycle_step():
	if cycle_step == action_cycle.size():
		cycle_step = 0

func useAction(battle_state):
	action_cycle[cycle_step].call(battle_state)
	pass
