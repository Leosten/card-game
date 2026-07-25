class_name CardData

extends Resource

enum targets {ALLY = 0, ENEMY = 0, ALL_ENEMIES = 0}
enum status_effects {STUN = 0, VULNERABLE = 0}
enum action_type {DAMAGE = 0, SHIELD_DAMAGE = 0, HEAL = 0, SHIELD = 0, STATUS = 0}
enum buff_types { DRAW  = 0 }

@export var id = 0
@export var character_deck = 0
@export var card_hand_position = 0
@export var name := ""
@export var damage := 0
@export var heal := 0
@export var actions := action_type
@export var status := status_effects
@export var description := ""
@export var cost := 0
@export var drawable := true
@export var discarded := false
@export var exhausted := false
@export var allowed_targets := targets
@export var artwork: Texture2D
