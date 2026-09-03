extends Control

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
var player_stats : PlayerStats
var draw_pile : Array[CardData] = []
var discard_pile : Array[CardData] = []
var exhaust_pile : Array[CardData] = []
var player_hand : Array[CardData] = []

var card_used = false
var enemy_turn = false
var card_hand_size

@onready var card_hand_anchor = %HandAnchor
@onready var draw_count = %DrawCount
@onready var discard_count = %DiscardCount

func _ready() -> void:
	player_stats = GameManager.battle_state.player_stats
	Events.turn_start.connect(on_turn_start)
	Events.turn_end.connect(on_turn_end)
	Events.battle_start.connect(on_battle_start)
	GameManager.battle_state.draw_cards.connect(on_draw_card_signal)
	GameManager.battle_state.player_stats.current_mana_changed.connect(on_mana_changed)
	card_animation_manager = CardAnimationManager.new()
	card_hand_size = card_hand_anchor.get_rect()
	card_animation_manager.hud_size = card_hand_size
	add_child(card_animation_manager)
	init_card_position()

func on_battle_start():
	player_draw_value = GameManager.battle_state.player_stats.draw_value
	init_player_piles()
	update_piles_count()

func on_draw_card_signal(nb):
	print("hud drawing cards")
	draw_cards(nb)

func init_card_position() -> void:
	card_hand_positions = CardUtils.init_card_position(card_hand_size.size, max_nb_of_cards, player_draw_value, card_size, margin_between_cards, left_margin, bottom_margin)

func draw_cards(draw_value) -> void:
	print("drawing %s cards ..." % str(draw_value))
	var cards : Array[CardData]= []
	var card_position = player_hand.size()
	for index in draw_value:
		if draw_pile.is_empty():
			_reshuffle_discard_into_draw()
		if not draw_pile.is_empty():
			var card_data = draw_pile.pop_front()
			card_data.hand_position = card_position
			player_hand.append(card_data)
			card_position += 1
			display_cards([card_data])
	update_piles_count()

func _reshuffle_discard_into_draw():
	print("resetting draw pile ...")
	# trigger animation
	draw_pile = discard_pile.duplicate()
	draw_pile.shuffle()
	discard_pile.clear()

func display_cards(cards_to_display: Array[CardData]) :
	var index = 0
	for card_data in cards_to_display:
		var card : Card = GameManager.card_manager.instantiate_card_scene(card_data)
		card.init_position(card_data.hand_position, card_animation_manager.right_out_of_bounds)
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		card.used.connect(_on_card_used)
		card.exhausted.connect(_on_card_exhausted)
		card_hand_anchor.add_child(card)
		displayed_hand.append(card)
		card.update()
		index += 1
	await card_animation_manager.cards_appear_animation(displayed_hand, card_hand_positions)

func _on_card_used(card : Card):
	print("card used : ", card.card_data.name)
	discard_card(card)

func _on_card_exhausted(card : Card):
	print("card exhausted : ", card.card_data.name)
	exhaust_card(card)
	
func discard_card(card: Card):
	card_used = true
	await card_animation_manager.use_card_animation(card)
	card_used = false
	player_hand.erase(card.card_data)
	card.queue_free()
	displayed_hand.erase(card)
	var index = 0
	for card_d in player_hand:
		card_d.hand_position = index
		index +=1
		
	#var index_2 = 0
	for displayed_card in displayed_hand:
		displayed_card.update()
	#
	discard_pile.append(card.card_data)
	reposition_cards()
	update_piles_count()

func exhaust_card(card: Card):
	card_used = true
	await card_animation_manager.exhaust_card_animation(card)
	card_used = false
	player_hand.erase(card.card_data)
	card.queue_free()
	displayed_hand.erase(card)
	var index = 0
	for card_d in player_hand:
		card_d.hand_position = index
		index +=1
		
	#var index_2 = 0
	for displayed_card in displayed_hand:
		displayed_card.update()
	#
	exhaust_pile.append(card.card_data)
	reposition_cards()
	update_piles_count()

func discard_all():
	print("CLEAR CARDS")
	for card in player_hand:
		card.hand_position = 0
		discard_pile.append(card)
	player_hand.clear()
	await card_animation_manager.clear_card_animation(displayed_hand)
	for card_scene : Card in displayed_hand:
		card_scene.queue_free()
	displayed_hand.clear()

func init_player_piles():
	discard_pile.clear()
	draw_pile.clear()
	player_deck = GameManager.get_player_deck()
	$DeckCard/DeckCount.text = str(player_deck.size())
	draw_pile = player_deck.duplicate()
	draw_pile.shuffle()
	
func update_piles_count():
	draw_count.text = str(draw_pile.size())
	discard_count.text = str(discard_pile.size())

func reposition_cards():
	for card in displayed_hand:
		var new_position = card_hand_positions[card.hand_position].position
		card.z_index = card.hand_position + 1
		CardAnimationManager.reposition_animation(card, new_position)
		card.base_position = new_position

func on_mana_changed():
	for card : Card in displayed_hand:
		card.update_cost_label(GameManager.battle_state.player_stats.current_mana)

func on_turn_end():
	enemy_turn = true
	#await discard_all()

func on_turn_start():
	print("Player turn start")
	enemy_turn = false
	draw_cards(player_draw_value)
	update_piles_count()

func _on_card_clicked(card: Card) -> void:
	if player_stats.current_mana < card.card_data.cost:
		CardAnimationManager.cannot_use_card_animation(card)
		return
	card_clicked.emit(card.card_data)

func _on_card_hovered(card: Card) -> void:
	print("card hovered")
	if card_used == true :
		return
	if enemy_turn == true:
		return

	if hovered_card == card:
		print("card already hovered")
		
		return
	# push previous card back down
	if hovered_card != null:
		CardAnimationManager.hover_back_animation(hovered_card)
		hovered_card.hovering = false
	hovered_card = card
	CardAnimationManager.hover_animation(card)
	card.hovering = true

func _on_card_hovered_out(card: Card) -> void:
	print("hovered out")
	if card_used == true:
		return
	if enemy_turn == true:
		return
	if hovered_card != card:
		print("hovering out different card")
		return
	CardAnimationManager.hover_back_animation(card)
	card.hovering = false
	hovered_card = null

func cleanup_fight():
	await discard_all()
	#CardAnimationManager.clean_tweens(displayed_hand)
