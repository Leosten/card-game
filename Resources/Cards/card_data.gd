class_name CardData

extends Resource

@export var id = 0
@export var character_deck = 0
@export var hand_position = 0
@export var name := ""
@export var damage := 0
@export var damage_modifier := 0
@export var heal := 0
@export var shield := 0
@export var actions : Array[CardUtils.action_type] = []
@export var status_effects : Array[StatusEffect]
@export var buffs : Array[Buff]
@export var description := ""
@export var cost := 0
@export var allowed_targets : Array[CardUtils.targets] = []
@export var artwork: Texture2D

@export var drawable = true
@export var magic_type : CardUtils.magic_type

func use(battle_state, enemy):
	pass
func useSelf(battle_state):
	pass
func useAll(battle_state):
	pass
func special_effects():
	pass
