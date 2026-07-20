class_name PlayerStats

extends Resource

@export var health : int = 100
@export var deck : Array[CardData] = []
@export var hand : Array[CardData] = []
@export var level_progression: int = 0
@export var stage_progression: int = 0

func _init(
	health = 0, 
	deck = [], 
	hand = [], 
	level_progression = 0, 
	stage_progression = 0
	):
		health = health
		deck = deck
		hand = hand
		level_progression = level_progression
		stage_progression = stage_progression
