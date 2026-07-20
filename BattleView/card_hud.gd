extends Node2D

const CARD_SCENE := preload("res://BattleView/Card.tscn")

@export var default_nb_of_cards := 4
@export var bottom_margin := -63.0
@export var margin_between_cards = 25
@export var card_size = 250
@export var max_nb_of_cards = 8

var player_hand: Array[Card] = []
var card_hand_position: Array[Area2D] = [] 

var cards_stacked : bool = false
var player_deck : Array[CardData] = []

func _ready() -> void:
	init_player_deck()
	init_card_position()
	_spawn_starting_hand()

func _process(_delta: float) -> void:
	#check_cards_fit()
	pass

func init_card_position() -> void:
	var viewport_size := get_viewport_rect().size
	
	for card_pos_index in range(max_nb_of_cards):
		var card_area = Area2D.new()
		var card_position := Vector2(
			(viewport_size.x - (card_pos_index * card_size) + margin_between_cards) - (viewport_size.x / default_nb_of_cards) ,
			viewport_size.y - bottom_margin
		)
		card_area.position = card_position
		card_hand_position.append(card_area)
		
func _spawn_starting_hand() -> void:
	if default_nb_of_cards <= 0:
		return

	for existing_card in player_hand:
		existing_card.queue_free()
	player_hand.clear()

	for index in default_nb_of_cards:
		var card := CARD_SCENE.instantiate() as Card
		card.position = card_hand_position[index].position
		card.z_index = index + 1
		add_child(card)
		player_deck[index].drawable = false
		card.init_card(str(index), player_deck[index])
		
		player_hand.append(card)

func check_cards_fit() -> void:
	if cards_stacked == true || player_hand.is_empty() :
		return
	var viewport_size := get_viewport_rect().size
		
	if player_hand[0] != null && player_hand[0].position.x <= viewport_size.x: 
		for card in player_hand:
			card.animation_left()
			cards_stacked = true

func init_player_deck():
	player_deck = GameManager.get_player_deck()
	player_deck.shuffle()
