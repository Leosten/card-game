extends Control

signal card_selected(card)

var player_deck : Array[CardData]

@onready var card_grid = %CardGrid
@onready var nb_label = %NbLabel
@onready var select_btn = %SelectButton

var selection = false
var selected_card : CardData = null

func _ready() -> void:
	self.z_index = 999
	player_deck = GameManager.battle_state.player_deck
	display_deck()

func with_data(extra_data : Dictionary):
	if extra_data.has("selection"):
		selection = extra_data.selection
		select_btn.visible = true

func display_deck():
	nb_label.text = str(player_deck.size())
	for card_data in player_deck:
		var card : Card = GameManager.card_manager.instantiate_card_scene(card_data)
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		card_grid.add_child(card)
		card.update()

func _on_card_hovered(card : Card):
	CardAnimationManager.zoom_in(card)

func _on_card_clicked(card : Card):
	if card == selected_card:
		selected_card = null
		CardAnimationManager.zoom_out(card)
	CardAnimationManager.zoom_in(card)
	selected_card = card.card_data

func _on_card_hovered_out(card : Card):
	if card == selected_card:
		return
	CardAnimationManager.zoom_out(card)

func select_card():
	card_selected.emit(selected_card)
	close()

func close():
	self.queue_free()

func _on_leave_button_pressed() -> void:
	close()

func _on_close_button_pressed() -> void:
	close()
