extends Control

signal next

var battle_state : BattleState = GameManager.battle_state
var cards : Array[CardData]
var selected_card : CardData = null

@onready var first_reward_box : CenterContainer = $%FirstReward
@onready var second_reward_box : CenterContainer = $%SecondReward
@onready var third_reward_box : CenterContainer = $%ThirdReward

func _ready() -> void:
	ScreenTransition.wipe_in(0.3)
	get_rewards()
	display_card_rewards()

func get_rewards():
	cards = GameManager.card_manager.get_card_rewards_by_deck(battle_state.player_stats.char_id)

func display_card_rewards():
	var positions : Array[CenterContainer]= [
		first_reward_box,
		second_reward_box,
		third_reward_box
	]
	var index = 0
	for card_data in cards:
		var pos = Vector2(positions[index].get_screen_position().x / 2, positions[index].get_screen_position().y / 2)
		var card : Card = GameManager.card_manager.get_card_scene()
		print("card data name ", card_data.name)
		card.init_data(card_data)
		card.init_position(0, pos)
		card.card_data.hand_position = 0
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		card.z_index = 1
		positions[index].add_child(card)
		card.update_text()
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_button_pressed() -> void:
	if selected_card != null:
		#TODO animation
		print("adding card to deck")
		GameManager.battle_state.player_deck.append(selected_card)
	Events.request_window_close.emit("reward")
	Events.request_window_open.emit("next_level")

func _on_ignore_button_pressed() -> void:
	Events.request_window_close.emit("reward")
	Events.request_window_open.emit("next_level")

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
