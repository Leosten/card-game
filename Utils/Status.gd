extends Resource

signal effect_changed

var icon: Texture2D
var stacks: int = 1
var type : StatusUtils.names
var target_entity: Targetable

func _init(target: Targetable, initial_stacks: int):
	target_entity = target
	stacks = initial_stacks

func add_stacks(amount: int) -> void:
	stacks += amount
	effect_changed.emit()

func on_turn_start() -> void:
	pass

func on_turn_end() -> void:
	pass

func on_card_played(_card_data) -> void:
	pass

func clear() -> void:
	pass
