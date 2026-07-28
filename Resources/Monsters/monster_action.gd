class_name MonsterAction

extends Resource

var name = ""
var type : MonsterUtils.action_types
var damage : int = 0

func _init(p_name : String, p_type : MonsterUtils.action_types, p_damage: int):
	name = p_name
	type = p_type
	damage = p_damage
	pass
