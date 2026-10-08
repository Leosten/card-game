extends Node

signal game_completed

var card_manager : CardManager
var stage_manager : StageManager
var monster_manager : MonsterManager
var shop_manager : ShopManager
var forge_manager : ForgeManager
var map_manager : MapManager
var ui_manager : UiManager
var grid_manager : GridManager
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
	forge_manager = ForgeManager.new()
	monster_manager = MonsterManager.new()
	grid_manager = GridManager.new()
	character_manager = CharacterManager.new()
	
	init_player(char_id)
	init_companion(companion_id)
	print("gamemanager init done")

func new_stage():
	map_manager.generate_map()
	monster_manager.load_stage_monsters(stage_manager.current_stage)

func init_player(char_id) -> void:
	var p_stats = PlayerStats.new()
	p_stats =  character_manager._get_starting_stats(char_id)
	battle_state.player_deck = card_manager.get_starting_deck(char_id)
	battle_state.player_stats = p_stats
	character_manager.load_character_scene(char_id, p_stats)
	print("player character init")
	
func init_companion(companion_id) -> void:
	var companion_stats = ElementalCompanionStats.new()
	companion_stats.grid_starting_pos = Vector2(0,2)
	battle_state.companion_stats = companion_stats
	character_manager.load_companion_scene(companion_id, companion_stats)
	print("companion character init")

func get_player_deck() -> Array[CardData]:
	return battle_state.player_deck

func get_player_char_id():
	return battle_state.player_stats.char_id

func get_viewport_size():
	return viewport_size
