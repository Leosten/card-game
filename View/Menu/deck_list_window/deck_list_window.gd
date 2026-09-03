extends Control

var player_deck : Array[CardData]

@onready var card_grid = %CardGrid
@onready var nb_label = %NbLabel

func _ready() -> void:
	self.z_index = 999
	player_deck = GameManager.battle_state.player_deck
	display_deck()

func display_deck():
	nb_label.text = str(player_deck.size())
	for card_data in player_deck:
		var card : Card = GameManager.card_manager.get_card_scene()
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.init_data(card_data)
		card_grid.add_child(card)
		card.update()

func _on_card_hovered(card : Card):
	CardAnimationManager.zoom_in(card)

func _on_card_hovered_out(card : Card):
	CardAnimationManager.zoom_out(card)

func close():
	self.queue_free()

func _on_leave_button_pressed() -> void:
	close()

func _on_close_button_pressed() -> void:
	close()
