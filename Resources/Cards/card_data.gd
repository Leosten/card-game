class_name CardData

extends Resource

signal data_changed
signal used(card)
signal exhausted(card)

@export var id = 0
@export var character_deck = 0
@export var hand_position = 0
@export var name := ""
@export var damage := 0
@export var damage_upgrade := 0
@export var heal := 0
@export var heal_upgrade := 0
@export var shield := 0
@export var shield_upgrade := 0
@export var draw_value := 0
@export var draw_value_upgrade := 0
@export var move_distance := 0
@export var move_distance_upgrade := 0
@export var channel_add_value := 0
@export var channel_add_value_upgrade := 0
@export var channel_remove_value := 0
@export var channel_remove_value_upgrade := 0
@export var actions : Array[CardUtils.action_type] = []
@export var exhaust : bool = false
@export var rally : bool = false
@export var status_stacks = 0
@export var status_stacks_upgrade = 0

var status_effects : Array[CardStatus] = []
var buffs : Array[CardStatus] = []

@export var upgrades : Array[CardUpgradeData] = []
@export var description := ""
@export var cost := 0
@export var allowed_targets : Array[CardUtils.targets] = []
@export var artwork: Texture2D = null
@export var magic_type : CardUtils.magic_type = CardUtils.magic_type.NONE
@export var tier : CardUtils.tier
@export var type : CardUtils.card_type
# Relative coordinates from target origin Vector2i(0, 0)
# Example: [Vector2i(0,0), Vector2i(1,0), Vector2i(-1,0)] -> 3-tile horizontal line
@export var area_pattern: Array[Vector2i] = []
@export var area_origin: Vector2i = Vector2i.ZERO

@export var grid_target: CardUtils.grid_target = CardUtils.grid_target.PLAYER

func use(battle_state : BattleState, enemy):
	pass
func use_self(battle_state : BattleState):
	pass
func use_all(battle_state : BattleState):
	pass
func use_special(battle_state : BattleState, enemy : Targetable = null) -> void:
	return
func channel_add() -> Array[CardUtils.magic_type]:
	return []
func channel_remove(channel_orbs: Array[CardUtils.magic_type]) -> Array[CardUtils.magic_type]:
	return []
func channel_use():
	pass
func conditions_check(battle_state : BattleState):
	pass

func upgrade():
	damage = damage_upgrade
	shield = shield_upgrade
	heal = heal_upgrade
	channel_add_value = channel_add_value_upgrade
	channel_remove_value = channel_remove_value_upgrade
	status_stacks = status_stacks_upgrade
	draw_value = draw_value_upgrade
