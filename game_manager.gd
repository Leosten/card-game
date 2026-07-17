extends Node
const CardData = preload("res://Resources/Cards/card_data.gd")
const starting_deck = preload("res://Resources/character_starting_deck.tres")

@export var player_hp : int = 100
@export var deck : Array[CardData] = []
@export var hand : Array[CardData] = []
@export var level_progression: int = 0
@export var stage_progression: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initPlayer() -> void:
	pass
func initBattle() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
