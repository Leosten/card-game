extends Node

const char1 : PackedScene = preload("res://Resources/Characters/1/Character1.tscn")
const PlayerStats = preload("res://Resources/Characters/player_stats.gd")
var player_stats : PlayerStats 

func _init():
	player_stats = PlayerStats.new()
	

static func get_character_scene(char_id):
	match char_id:
		1:
			print("Character number 1 scene loaded")
			return char1.instantiate()
		2:
			print("Two are better than one!")

static func _get_character_starting_deck(character_id):
	match character_id:
		1:
			print("Character number 1 deck")
			return [0,0,0,1,1,2]
		2:
			print("Two are better than one!")

func _get_starting_stats(char_id):
	match char_id:
		1:
			print("Character number 1 stats")
			player_stats.char_id = char_id
			player_stats.health = 100
			return player_stats
		2:
			print("Two are better than one!")
