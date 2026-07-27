extends Node2D

signal card_clicked(card_data: CardData)

@export var bottom_margin := 0
@export var left_margin = 250
@export var margin_between_cards = 20
@export var card_size = 250
@export var max_nb_of_cards = 8

var displayed_hand: Array[Card] = []
var card_hand_position: Array[Area2D] = [] 
var cards_stacked : bool = false
var player_deck : Array[CardData] = []
var hovered_card: Card = null

var draw_value
var draw_pile : Array[CardData] = []
var discard_pile : Array[CardData] = []
var player_hand : Array[CardData] = []

func _ready() -> void:
	draw_value = GameManager.battle_state["player_stats"].draw_value
	init_player_deck()
	init_card_position()
	draw_cards(draw_value)
	display_hand()
	update_piles_count()

func _process(_delta: float) -> void:
	pass

func init_card_position() -> void:
	var viewport_size := get_viewport_rect().size
	
	for card_pos_index in range(max_nb_of_cards):
		var card_area = Area2D.new()
		var card_position := Vector2(
			(viewport_size.x - left_margin - (card_pos_index * card_size) + margin_between_cards) - (viewport_size.x / draw_value),
			viewport_size.y - bottom_margin
		)
		card_area.position = card_position
		card_hand_position.append(card_area)
		print("card positions init")

func draw_cards(draw_value) -> void:
	if draw_value <= 0:
		return

	for existing_card in player_hand:
		existing_card.queue_free()
	player_hand.clear()

	for index in draw_value:
		var card_data = player_deck[index]
		card_data.hand_position = index
		player_hand.append(card_data)
	print("hand cards ready")

func display_hand() :
	for existing_card in displayed_hand:
		existing_card.queue_free()
	displayed_hand.clear()
	
	for card_data in player_hand:
		var card : Card = GameManager.card_manager.get_card_scene()
		card.init_card(card_data.hand_position, card_data, card_hand_position[card_data.hand_position].position)
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		add_child(card)
		displayed_hand.append(card)
	print("hand cards spawned")

func discard_card(card_data: CardData):
	player_hand.remove_at(card_data.hand_position)
	displayed_hand[card_data.hand_position].queue_free()
	displayed_hand.remove_at(card_data.hand_position)
	var index = 0
	for card_d in player_hand:
		card_d.hand_position = index
		index +=1
	
	var index_2 = 0
	for displayed_card in displayed_hand:
		displayed_card.hand_position = index_2
		index_2 +=1
	
	reposition_cards()
	card_data.hand_position = 0
	discard_pile.append(card_data)
	

func discard_all():
	for card in player_hand:
		card.hand_position = 0 
		discard_pile.append(card)
	player_hand.clear()
	
	for card_scene in displayed_hand:
		card_scene.queue_free()
	displayed_hand.clear()

func init_player_deck():
	player_deck = GameManager.get_player_deck()
	player_deck.shuffle()
	draw_pile = player_deck

func update_piles_count():
	$DrawPile/DrawCount.text = str(draw_pile.size())
	$DiscardPile/DiscardCount.text = str(discard_pile.size())

func reposition_cards():
	for card in displayed_hand:
		var new_position = card_hand_position[card.hand_position].position
		card.z_index = card.hand_position + 1
		CardUtils.reposition_animation(card, new_position)
		card.base_position = new_position

func update_displayed_hand(battle_state : Dictionary):
	for card : Card in displayed_hand:
		card.update_cost_label(CharacterUtils.get_current_mana(battle_state))
		
func new_turn():
	draw_cards(draw_value)
	display_hand()
	update_piles_count()
	
func _on_card_clicked(card_hand_position: int) -> void:
	print("Clicked: ", card_hand_position)
	var card_data = CardUtils.find_card_by_position(player_hand, card_hand_position)
	card_clicked.emit(card_data)

func _on_card_hovered(card: Card) -> void:
	if hovered_card == card:
		return
	# push previous card back down
	if hovered_card != null:
		CardUtils.hover_back_animation(hovered_card)
		hovered_card.hovering = false

	hovered_card = card
	CardUtils.hover_animation(card)
	card.hovering = true

func _on_card_hovered_out(card: Card) -> void:
	if hovered_card != card:
		return
	CardUtils.hover_back_animation(card)
	card.hovering = false
	hovered_card = null
