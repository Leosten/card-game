class_name Targetable

extends Resource

signal damage_taken(value)
signal damage_shielded(value)
signal damage_protected(value)
signal shield_broken(value)
signal buffing(buff : Buff)
signal buffed(buff : Buff)
signal statused(status_effect : StatusEffect)
signal healed(value)
signal shielded(value)

signal acting(action_type)
signal death

signal stats_changed

@export var buffs : Array[Buff] = []
@export var status_effects : Array[StatusEffect] = []
@export var health : int = 0
@export var max_health : int = 0
@export var shield : int = 0

func _init():
	pass
