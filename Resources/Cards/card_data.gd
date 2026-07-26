@abstract class_name CardData

extends Resource

@export var id = 0
@export var character_deck = 0
@export var card_hand_position = 0
@export var name := ""
@export var damage := 0
@export var damage_modifier := 0
@export var heal := 0
@export var actions := CardUtils.action_type
@export var status := StatusUtils.status_effects
@export var description := ""
@export var cost := 0
@export var drawable := true
@export var discarded := false
@export var exhausted := false
@export var allowed_targets := CardUtils.targets
@export var artwork: Texture2D

func use(battle_state, enemy):
	pass
func useSelf(battle_state):
	pass
func useAll(battle_state):
	pass
