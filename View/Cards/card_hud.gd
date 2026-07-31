extends CanvasLayer

signal card_clicked(card_data: CardData)

@export var bottom_margin :=20
@export var left_margin = 100
@export var margin_between_cards = 10
@export var card_size = 250
@export var max_nb_of_cards = 10

var card_animation_manager : CardAnimationManager
var displayed_hand: Array[Card] = []
var card_hand_positions: Array[Area2D] = [] 
var cards_stacked : bool = false
var player_deck : Array[CardData] = []
var hovered_card: Card = null

var player_draw_value
var draw_pile : Array[CardData] = []
var discard_pile : Array[CardData] = []
var player_hand : Array[CardData] = []
var card_used = false
var enemy_turn = false
var card_hand_size

@onready var cardhandhud = $CardHand.size
@onready var card_hand_anchor = $CardHand/HandAnchor

func _ready() -> void:
	card_animation_manager = CardAnimationManager.new()
	card_hand_size = card_hand_anchor.get_rect()

	card_animation_manager.hud_size = card_hand_size
	add_child(card_animation_manager)
	player_draw_value = GameManager.battle_state.player_stats.draw_value
	init_player_deck()
	init_card_position()
	draw_cards(player_draw_value)
	display_hand()
	update_piles_count()

	
func _process(_delta: float) -> void:
	pass

func init_card_position() -> void:
	card_hand_positions = CardUtils.init_card_position(card_hand_size.size, max_nb_of_cards, player_draw_value, card_size, margin_between_cards, left_margin, bottom_margin)

func draw_cards(draw_value) -> void:
	if draw_value <= 0:
		return
	check_draw_pile_size_reset()
	var draw_pile_remaining = draw_pile.size()
	if (draw_value >= draw_pile_remaining):
		draw_value = draw_pile_remaining

	for index in draw_value:
		var card_data = draw_pile.pop_front()
		card_data.hand_position = index
		player_hand.append(card_data)
	update_piles_count()

func check_draw_pile_size_reset():
	if draw_pile.is_empty() :
		# trigger animation
		draw_pile = discard_pile.duplicate()
		draw_pile.shuffle()
		discard_pile.clear()

func display_hand() :
	for existing_card in displayed_hand:
		existing_card.queue_free()
	displayed_hand.clear()
	
	var index = 0
	for card_data in player_hand:
		var card : Card = GameManager.card_manager.get_card_scene()
		card.init_card(card_data.hand_position, card_data, card_animation_manager.right_out_of_bounds)
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		card_hand_anchor.add_child(card)
		displayed_hand.append(card)
		index += 1
	await card_animation_manager.cards_appear_animation(displayed_hand, card_hand_positions)

func discard_card(card_data: CardData):
	card_used = true
	await card_animation_manager.use_card_animation(displayed_hand[card_data.hand_position])
	card_used = false
	player_hand.erase(card_data)
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
	discard_pile.append(card_data)
	reposition_cards()
	update_piles_count()

func discard_all():
	for card in player_hand:
		card.hand_position = 0 
		discard_pile.append(card)
	player_hand.clear()
	await card_animation_manager.clear_card_animation(displayed_hand)
	for card_scene : Card in displayed_hand:
		card_scene.queue_free()
	displayed_hand.clear()

func init_player_deck():
	player_deck = GameManager.get_player_deck()
	$DeckCard/DeckCount.text = str(player_deck.size())
	player_deck.shuffle()
	draw_pile = player_deck

func update_piles_count():
	$DrawPile/DrawCount.text = str(draw_pile.size())
	$DiscardPile/DiscardCount.text = str(discard_pile.size())
	pass

func reposition_cards():
	for card in displayed_hand:
		var new_position = card_hand_positions[card.hand_position].position
		card.z_index = card.hand_position + 1
		CardUtils.reposition_animation(card, new_position)
		card.base_position = new_position

func update_displayed_hand_cost(battle_state : BattleState):
	for card : Card in displayed_hand:
		card.update_cost_label(CharacterUtils.get_current_mana(battle_state))

func end_turn():
	enemy_turn = true
	discard_all()

func new_turn():
	enemy_turn = false
	check_draw_pile_size_reset()
	draw_cards(player_draw_value)
	display_hand()
	update_piles_count()

func _on_card_clicked(card_data: CardData) -> void:
	card_clicked.emit(card_data)

func _on_card_hovered(card: Card) -> void:
	if card_used == true :
		return
	if enemy_turn == true:
		return

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
	print("hovered out!")
	if card_used == true :
		return
	if hovered_card != card:
		return
	CardUtils.hover_back_animation(card)
	card.hovering = false
	hovered_card = null
