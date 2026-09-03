extends Node

signal game_completed

var card_manager : CardManager
var stage_manager : StageManager
var shop_manager : ShopManager
var map_manager : MapManager
var ui_manager : UiManager
var character_manager : CharacterManager
var battle_state : BattleState
var char_scene : PackedScene = null
var companion_scene : PackedScene = null

@export var cards : Array[CardData] = []
@export var char_id = 0;
@export var companion_id = 0;

var viewport_size

func _ready() -> void:
	viewport_size = get_viewport().size
	# select char id at start menu
	battle_state = BattleState.new()
	ui_manager = UiManager.new()
	char_id = 0
	companion_id = 0
	card_manager = CardManager.new()
	stage_manager = StageManager.new()
	map_manager = MapManager.new()
	shop_manager = ShopManager.new()
	character_manager = CharacterManager.new()
	
	init_player(char_id)
	init_companion(companion_id)
	print("gamemanager init done")

func init_player(char_id) -> void:
	var p_stats = PlayerStats.new()
	p_stats =  character_manager._get_starting_stats(char_id)
	battle_state.player_deck = card_manager.get_starting_deck(char_id)
	battle_state.player_stats = p_stats

func init_companion(companion_id) -> void:
	battle_state.player_stats.companion_stats = ElementalCompanionStats.new()
	print("companion stats init")

func get_player_deck() -> Array[CardData]:
	return battle_state.player_deck

func get_character_scene() :
	if (char_scene != null) :
		return char_scene
	return character_manager.get_character_scene(char_id)

func get_companion_scene():
	return character_manager.get_companion_scene(companion_id)

func get_player_char_id():
	return battle_state.player_stats.char_id

func get_viewport_size():
	return viewport_size
