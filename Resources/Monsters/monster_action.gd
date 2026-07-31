class_name MonsterAction

extends Resource

@export var name = ""
@export var type : MonsterUtils.action_types
@export var damage : int = 0
@export var shield : int = 0

func _init(p_name : String, p_type : MonsterUtils.action_types, p_damage: int, p_shield = 0):
	name = p_name
	type = p_type
	damage = p_damage
	shield = p_shield
	
	pass
