extends Node

const CardManager = preload("res://Manager/card_manager.gd")
const UiManager = preload("res://Manager/ui_manager.gd")
const PlayerStats = preload("res://Resources/Characters/player_stats.gd")
const CharacterManager = preload("res://Manager/character_manager.gd")

var card_manager : CardManager
var ui_manager : UiManager
var character_manager : CharacterManager
var battle_state : BattleState
var char_scene : PackedScene = null
@export var player_stats : PlayerStats
@export var cards : Array[CardData] = []
@export var player_deck: Array[CardData] = []
@export var level_monsters: Array[MonsterData] = []
@export var current_level = 1;
@export var current_stage = 1;
@export var char_id = 0;
var viewport_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport().size
	# select char id at start menu
	battle_state = BattleState.new()
	ui_manager = UiManager.new()
	ui_manager.load_all_icons()
	char_id = 1
	card_manager = CardManager.new()
	character_manager = CharacterManager.new()
	card_manager.load_all_cards()
	
	init_cards()
	init_player(char_id)
	print("init done")

func init_cards() -> void:
	var all_cards = card_manager.get_all_cards()
	for card in all_cards:
		cards.append(card.duplicate())
	print("cards loaded");

func init_player(char_id) -> void:
	var p_stats = PlayerStats.new()
	p_stats =  character_manager._get_starting_stats(char_id)
	battle_state.player_deck = card_manager.get_starting_deck(char_id)
	battle_state.player_stats = p_stats

func get_player_deck() -> Array[CardData]:
	return battle_state.player_deck

func get_character_scene() :
	if (char_scene != null) :
		return char_scene
	return character_manager.get_character_scene(char_id)

func get_player_char_id():
	return player_stats.char_id
	
func get_battle_state() -> BattleState:
	return battle_state

func update_battle_state(battle_state : BattleState) -> BattleState:
	battle_state = battle_state
	return battle_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_viewport_size():
	return viewport_size
