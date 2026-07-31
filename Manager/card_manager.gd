class_name CardManager
extends Node

const CardData = preload("res://Resources/Cards/card_data.gd")
const PlayerManager = preload("res://Manager/character_manager.gd")
const Card = preload("res://View/Cards/card.tscn")

#@export var nb_of_cards : int = 5
@export var cards : Array[CardData] = []
@export var decks : Array = []
var nb_of_decks = 1
var deck_common_name = "common"

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	load_all_cards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_all_cards() -> void:
	for deck in nb_of_decks:
		var deck_data = load("res://Resources/Cards/deck_"+ str(deck) +"/deck_data.gd")
		var nb_of_cards = deck_data.new().get_deck_size()
		var deck_cards = []
		for card_index in nb_of_cards:
			var card = load("res://Resources/Cards/deck_"+ str(deck)+ "/card_"+ str(card_index)+ ".tres")
			if card == null:
				print("ERROR : could not load card %s" % str(card_index))
			deck_cards.append(card.duplicate())
		decks.append(deck_cards)

func get_all_cards() -> Array[CardData]:
	return cards

func get_starting_deck(character_id):
	var character_deck = PlayerManager._get_character_starting_deck(character_id)
	var deck : Array[CardData] = []

	for cards_id in character_deck:
		deck.append(decks[character_id][cards_id].duplicate())
	return deck

func list_cards() -> void:
	for card in cards:
		print("card name is %s" % card.name)

func get_card_scene():
	return Card.instantiate()
