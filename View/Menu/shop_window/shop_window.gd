extends Control

var shop_manager : ShopManager
var cards_to_buy: Array[CardData]
@onready var cards_container = %CardsContainer
var card_item_scene = preload("res://View/Menu/shop_window/card_item.tscn")


func _ready() -> void:
	shop_manager = GameManager.shop_manager
	cards_to_buy = GameManager.card_manager.get_random_cards_by_deck(GameManager.battle_state.player_stats.char_id, 5)
	display_cards_to_buy()

func display_cards_to_buy():
	for card_data in cards_to_buy:
		var card : Card = GameManager.card_manager.instantiate_card_scene(card_data)
		var card_item = card_item_scene.instantiate()
		card_item.init(card, shop_manager.get_card_price(card_data))
		#card.hovered.connect(_on_card_hovered)
		#card.hovered_out.connect(_on_card_hovered_out)
		#card.clicked.connect(_on_card_clicked)
		cards_container.add_child(card_item)

func display_card_upgrades():
	
	pass

func buy_card(card : CardData):
	pass
func buy_upgrade(upgrade : CardUpgradeData):
	pass
