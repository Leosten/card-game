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
@export var damage_modifier := 0
@export var heal := 0
@export var shield := 0
@export var draw_value := 0
@export var actions : Array[CardUtils.action_type] = []
@export var exhaust : bool = false
@export var rally : bool = false
var status_effects : Array[CardStatus] = []
var buffs : Array[CardStatus] = []

@export var upgrades : Array[CardUpgradeData] = []
@export var description := ""
@export var cost := 0
@export var allowed_targets : Array[CardUtils.targets] = []
@export var artwork: Texture2D
@export var magic_type : CardUtils.magic_type = CardUtils.magic_type.NONE
@export var tier : CardUtils.tier
@export var type : CardUtils.card_type

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
