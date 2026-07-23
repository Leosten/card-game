class_name MonsterData
extends Resource

enum MonsterType {COMMON, MINIBOSS, BOSS}

@export var id = 0
@export var name := ""
@export var type : MonsterType = MonsterType.COMMON 
@export var health := 0
@export var shield := 0
@export var status_effects := []
@export var action_cycle := []
@export var description := ""

# Called when the node enters the scene tree for the first time.
func _init():
	pass
