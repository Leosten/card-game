class_name MonsterAction

extends Resource

@export var name = ""
@export var type : MonsterUtils.action_types
@export var damage : int = 0
@export var shield : int = 0
@export var heal : int = 0
@export var area_pattern: Array[Vector2i] = []
@export var area_origin: Vector2i = Vector2i.ZERO

func _init(p_name : String = "", p_type : MonsterUtils.action_types = MonsterUtils.action_types.DAMAGE, p_damage: int = 0, p_shield = 0, p_heal = 0):
	name = p_name
	type = p_type
	damage = p_damage
	shield = p_shield
	heal = p_heal
	pass
