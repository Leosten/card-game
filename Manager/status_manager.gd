class_name StatusManager
extends Node
signal statuses_updated

var _statuses: Dictionary = {} # name -> StatusEffect instance
@onready var owner_entity: Targetable

func _init(parent_owner_entity : Targetable):
	owner_entity = parent_owner_entity

func apply_status(card_statuses: Array[CardStatus]) -> void:
	for status in card_statuses:
		if _statuses.has(status.type):
			# If target already has this buff, increase the stack count
			_statuses[status.type].add_stacks(status.stacks)
		else:
			# Create a new status effect instance
			var new_status: Status = _create_status_instance(status.type, status.stacks, status.modifiable_value)
			if new_status:
				new_status.effect_changed.connect(_on_status_changed.bind(new_status))
				_statuses[status.type] = new_status
		print("status applied")
		print( "current statuses : ", _statuses)
		statuses_updated.emit()

func _create_status_instance(status_name: StatusUtils.names, stacks: int, modifiable_value : int) -> Status:
	match status_name:
		StatusUtils.names.VULNERABLE:
			return VulnerableStatus.new(owner_entity, stacks)
		StatusUtils.names.STUN:
			return StunStatus.new(owner_entity)
		StatusUtils.names.STRENGTH:
			return null
		StatusUtils.names.FIRE_AFFINITY:
			return FireAffinityStatus.new(owner_entity, stacks, modifiable_value)
		StatusUtils.names.REGEN:
			return null
		StatusUtils.names.FROZEN_BITE:
			return FrozenBiteStatus.new(owner_entity, stacks, modifiable_value)
		_:
			push_warning("Unknown status ID: %s" % status_name)
			return null

func trigger_turn_start() -> void:
	for status in _statuses.values():
		status.on_turn_start()
	_cleanup_expired_statuses()
	statuses_updated.emit()

func trigger_turn_end() -> void:
	for status in _statuses.values():
		status.on_turn_end()
	_cleanup_expired_statuses()
	if _statuses.has(StatusUtils.names.FORESIGHT) == false:
		owner_entity.shield = 0
		owner_entity.stats_changed.emit()
	statuses_updated.emit()

func _on_status_changed(status: Status) -> void:
	if status.stacks <= 0:
		_cleanup_expired_statuses()
	statuses_updated.emit()

func _cleanup_expired_statuses() -> void:
	var to_remove = []
	for s_name in _statuses:
		if _statuses[s_name].stacks <= 0:
			to_remove.append(s_name)
	for s_name in to_remove:
		_statuses.erase(s_name)
	if not to_remove.is_empty():
		statuses_updated.emit()

func clear_all() -> void:
	for status in _statuses.values():
		status.clear()
	_statuses.clear()
	statuses_updated.emit()

func get_statuses() -> Dictionary:
	return _statuses

func cleanup_fight():
	clear_all()
