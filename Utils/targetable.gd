class_name Targetable

extends Resource

signal damage_taken(value)
signal damage_shielded(value)
signal damage_protected(value)
signal shield_broken(value)
signal buffing(buff : StatusUtils.names)
signal buffed(buff : StatusUtils.names)
signal statused(status_effect : StatusUtils.names)
signal healed(value)
signal shielded(value)

signal acting(action_type)
signal death

signal stats_changed

@export var grid_starting_pos : Vector2
@export var grid_position : Vector2

@export var health : int = 0
@export var max_health : int = 0
@export var shield : int = 0

var status_manager : StatusManager

func _init():
	status_manager = StatusManager.new(self)
	pass
