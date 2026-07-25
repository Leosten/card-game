extends Node

const PlayerStats = preload("res://Resources/Characters/player_stats.gd")
var player_stats : PlayerStats 

func _init():
	player_stats = PlayerStats.new()

static func get_character_scene(char_id):
	match char_id:
		1:
			print("Character number 1 scene loading")
			var char : PackedScene = preload("res://Resources/Characters/1/Character1.tscn")
			
			if char == null:
				printerr("Cannot load character scene %s" % str(char_id))
				return
				
			return char.instantiate()

static func _get_character_starting_deck(character_id):
	match character_id:
		1:
			print("Character number 1 deck")
			return [0,0,0,1,1,2]

func _get_starting_stats(char_id):
	match char_id:
		1:
			print("Character number 1 stats")
			player_stats.char_id = char_id
			player_stats.health = 100
			return player_stats
