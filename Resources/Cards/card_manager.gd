class_name CardManager
extends Resource
const CardData = preload("res://Resources/Cards/card_data.gd")
const StartingDecks = preload("res://Resources/Characters/starting_decks.gd")

@export var nb_of_cards : int = 3
@export var cards : Array[CardData] = []

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	load_all_cards()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_all_cards() -> void:
	for card_index in nb_of_cards:
		var card = load("res://Resources/Cards/Data/"+ str(card_index)+ ".tres")
		cards.append(card.duplicate())	

func get_all_cards() -> Array[CardData]:
	return cards

func get_starting_deck(character_id):
	var character_deck = StartingDecks._get_character_starting_deck(1)
	var deck : Array[CardData] = []
	print(character_deck)
	for cards_id in character_deck:
		deck.append(cards[cards_id].duplicate())
	return deck
