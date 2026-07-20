class_name StartingDecks

extends Resource

static func _get_character_starting_deck(character_id):
	match character_id:
		1:
			print("Character number 1 deck")
			return [0,0,0,1,1,2]
		2:
			print("Two are better than one!")

	
