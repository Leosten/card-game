class_name CharacterManager
extends Node

## Manager for character visual and stats related stuff

var player_stats : PlayerStats
var player_character : TargetCharacter
var companion_character : TargetCharacter

var player_shop_position : Vector2 = Vector2(
	GameManager.viewport_size.x - 1550,
	GameManager.viewport_size.y - 450
)
var companion_shop_position : Vector2 = Vector2(
	GameManager.viewport_size.x - 1300,
	GameManager.viewport_size.y - 400
)

func _init():
	player_stats = PlayerStats.new()
	Events.battle_start.connect(_on_battle_start)
	Events.shop_start.connect(_on_shop_start)
	Events.forge_start.connect(_on_forge_start)

func _on_battle_start():
	set_main_char_battle_position()
	set_companion_char_battle_position()

func _on_shop_start():
	set_main_char_shop_position()
	set_companion_char_shop_position()

func _on_forge_start():
	set_main_char_shop_position()
	set_companion_char_shop_position()

func load_character_scene(char_id, p_stats : PlayerStats):
	match char_id:
		0:
			print("Character number 0 scene loading")
			#var char_scene : PackedScene = preload("res://Resources/Characters/0/character_0.tscn")
			var char_scene = preload("res://Resources/Characters/PlayerCharacter/player_character.tscn")
			
			if char_scene == null:
				printerr("Cannot load character scene %s" % str(char_id))
				return null
			player_character = char_scene.instantiate()
			player_character.init(p_stats)

func get_character_scene():
	return player_character

func load_companion_scene(companion_id, c_stats: CompanionStats):
	match companion_id:
		0:
			print("Companion number 0 scene loading")
			var companion = preload("res://Resources/Characters/Companions/companion_0.tscn")
			
			if companion == null:
				printerr("Cannot load companion scene %s" % str(companion_id))
				return null
			companion_character = companion.instantiate()
			companion_character.init(c_stats)

func get_companion_scene():
	return companion_character

func set_main_char_battle_position():
	GameManager.grid_manager.place_unit_on_tile(player_character, GameManager.battle_state.player_stats.grid_starting_pos)

func set_companion_char_battle_position():
	GameManager.grid_manager.place_unit_on_tile(companion_character, GameManager.battle_state.companion_stats.grid_starting_pos)

func set_main_char_shop_position():
	player_character.position = player_shop_position

func set_companion_char_shop_position():
	companion_character.position = companion_shop_position

static func _get_character_starting_deck(character_id):
	match character_id:
		0:
			print("Character number 0 starting deck")
			#return ["beam","beam","beam","beam","beam", "defend","defend","defend", "defend","fire_affinity","defend","early_call","fire_beam"]
			return ["beam","beam","beam","ultra_beam","beam", "evade","evade","evade", "evade",]
			#return ["beam",  "defend", "wind_chill", "lightning", "heal", "fire_beam", "early_call", "prediction", "protect_me", "careful_hit"]
			#return ["beam", "glacier_shield", "prediction", "fire_affinity", "panic_trade"]
			#return ["fire_beam", "early_call", "wind_chill", "protect_me", "careful_hit","lightning"]

func _get_starting_stats(char_id):
	match char_id:
		0:
			print("Character number 0 starting stats")
			player_stats.char_id = char_id
			player_stats.health = 90
			player_stats.max_health = 90
			player_stats.current_mana = 10
			player_stats.max_mana = 10
			player_stats.draw_value = 5
			player_stats.grid_starting_pos = Vector2(0,1)
			return player_stats
