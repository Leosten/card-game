extends Control

signal next

var battle_state : BattleState = GameManager.battle_state
var cards : Array[CardData]
var selected_card : CardData = null
var nb_of_card_reward : int = 0
@onready var card_reward_container = %CardRewardContainer

func _ready() -> void:
	nb_of_card_reward = GameManager.battle_state.player_stats.nb_card_reward
	get_rewards()
	display_card_rewards()

func get_rewards():
	cards = GameManager.card_manager.get_random_cards_by_deck(battle_state.player_stats.char_id, nb_of_card_reward)

func display_card_rewards():
	var index = 0
	for card_data in cards:
		var pos = Vector2(0,0)
		var card : Card = GameManager.card_manager.instantiate_card_scene(card_data)
		print("card data name ", card_data.name)
		card.init_position(0, pos)
		card.card_data.hand_position = 0
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		card.z_index = 1
		
		var center = CenterContainer.new()
		center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		center.add_child(card)
		card_reward_container.add_child(center)
		card.update()
		index += 1

func _on_next_button_pressed() -> void:
	if selected_card != null:
		#TODO animation
		print("adding card to deck")
		GameManager.battle_state.player_deck.append(selected_card)
	Events.request_window_close.emit("reward")
	Events.request_window_open.emit("map", {"selection" : true})

func _on_ignore_button_pressed() -> void:
	Events.request_window_close.emit("reward")
	Events.request_window_open.emit("map", {"selection" : true})

func _on_card_hovered(card : Card):
	if card == selected_card:
		return
	CardAnimationManager.zoom_in(card)

func _on_card_hovered_out(card : Card):
	if (card == selected_card):
		return
	CardAnimationManager.zoom_out(card)

func _on_card_clicked(card : Card):
	if card == selected_card:
		selected_card = null
		return
	selected_card = card.card_data
