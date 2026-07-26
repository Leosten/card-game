extends Node

const CardManager = preload("res://Manager/card_manager.gd")
const PlayerStats = preload("res://Resources/Characters/player_stats.gd")
const CharacterManager = preload("res://Manager/character_manager.gd")

var card_manager : CardManager
var character_manager : CharacterManager
var battle_state : Dictionary
@export var player_stats : PlayerStats
@export var cards : Array[CardData] = []
@export var player_deck: Array[CardData] = []
@export var level_monsters: Array[MonsterData] = []
@export var current_level = 1;
@export var current_stage = 1;
@export var char_id = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# select char id at start menu
	char_id = 1
	card_manager = CardManager.new()
	character_manager = CharacterManager.new()
	card_manager.load_all_cards()
	init_cards()
	init_player(char_id)
	battle_state["player_stats"] = player_stats
	battle_state["player_deck"] = player_deck
	print("init done")

func init_cards() -> void:
	var all_cards = card_manager.get_all_cards()
	for card in all_cards:
		cards.append(card.duplicate())
	print("cards loaded");

func init_player(char_id) -> void:
	player_deck = card_manager.get_starting_deck(char_id)
	player_stats = character_manager._get_starting_stats(char_id)
	print("player health is %s" % player_stats.health)

func get_player_deck() :
	return battle_state['player_deck']

func get_character_scene() :
	return character_manager.get_character_scene(char_id)

func get_player_char_id():
	return player_stats.char_id
	
func get_battle_state() -> Dictionary:
	return battle_state

func update_battle_state(battle_state : Dictionary):
	battle_state = battle_state
	return battle_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
