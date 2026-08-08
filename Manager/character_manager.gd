extends Node

var player_stats : PlayerStats 

func _init():
	player_stats = PlayerStats.new()

static func get_character_scene(char_id):
	match char_id:
		0:
			print("Character number 0 scene loading")
			var char : PackedScene = preload("res://Resources/Characters/0/Character0.tscn")
			
			if char == null:
				printerr("Cannot load character scene %s" % str(char_id))
				return null
				
			return char.instantiate()

static func get_companion_scene(companion_id):
	match companion_id:
		0:
			print("Companion number 0 scene loading")
			var companion : PackedScene = preload("res://Resources/Characters/Companions/companion_0.tscn")
			
			if companion == null:
				printerr("Cannot load companion scene %s" % str(companion_id))
				return null
				
			return companion.instantiate()

static func _get_character_starting_deck(character_id):
	match character_id:
		0:
			print("Character number 0 starting deck")
			#return ["beam","beam","beam","beam", "defend","defend","defend", "defend","wind_chill","wind_chill","lightning","lightning"]
			return ["beam",  "defend", "wind_chill", "lightning", "heal"]
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
			return player_stats
