extends Node

const CardManager = preload("res://Resources/Cards/card_manager.gd")
const PlayerStats = preload("res://Resources/Characters/player_stats.gd")
var card_manager : CardManager
@export var player_stats : PlayerStats
@export var cards : Array[CardData] = []
@export var player_deck: Array[CardData] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_manager = CardManager.new()
	player_stats = PlayerStats.new()
	init_cards()
	init_player()
	#list_cards()
	print("init done")

func init_cards() -> void:
	var all_cards = card_manager.get_all_cards()
	for card in all_cards:
		cards.append(card.duplicate())
	print("cards loaded");

func init_player_deck():
	player_deck = card_manager.get_starting_deck(1)

func list_cards() -> void:
	for card in cards:
		print("card name is %s" % card.name)

func init_player() -> void:
	init_player_deck()
	player_stats.health = 100
	print("player health is %s" % player_stats.health)

func get_player_deck() :
	return player_deck

func init_battle() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
