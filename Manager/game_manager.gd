extends Node

const CardManager = preload("res://Manager/card_manager.gd")
const UiManager = preload("res://Manager/ui_manager.gd")
const PlayerStats = preload("res://Resources/Characters/player_stats.gd")
const CharacterManager = preload("res://Manager/character_manager.gd")

signal game_completed

var max_current_level = 5
var max_current_stage = 1

var card_manager : CardManager
var ui_manager : UiManager
var character_manager : CharacterManager
var battle_state : BattleState
var char_scene : PackedScene = null
var companion_scene : PackedScene = null

@export var cards : Array[CardData] = []
@export var current_level = 1;
@export var current_stage = 1;

@export var char_id = 0;
@export var companion_id = 0;

var viewport_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport().size
	# select char id at start menu
	battle_state = BattleState.new()
	ui_manager = UiManager.new()
	char_id = 0
	companion_id = 0
	card_manager = CardManager.new()
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
	battle_state.companion_stats = ElementalCompanionStats.new()
	print("companion stats init")

func get_player_deck() -> Array[CardData]:
	return battle_state.player_deck

func get_character_scene() :
	if (char_scene != null) :
		return char_scene
	return character_manager.get_character_scene(char_id)

func get_companion_scene():
	#if (companion_scene != null) :
		#return companion_scene
	return character_manager.get_companion_scene(companion_id)

func get_player_char_id():
	return battle_state.player_stats.char_id

func get_battle_state() -> BattleState:
	return battle_state

func update_battle_state(battle_state : BattleState) -> BattleState:
	battle_state = battle_state
	return battle_state

func victory_progress():
	if current_stage == max_current_stage and current_level == max_current_level:
		Events.game_completed.emit()
		print("game completed")
		return
	if current_level == max_current_level:
		current_level = 1
		max_current_stage +=1
		print("stage completed")
		return
	print("level progress")
	current_level += 1

func get_viewport_size():
	return viewport_size
