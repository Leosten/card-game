extends Control

var shop_manager : ShopManager
var cards_to_buy: Array[CardData]
var upgrades_to_buy: Array[CardUpgradeData]

@onready var cards_container = %CardsContainer
@onready var upgrades_container = %UpgradesContainer

var card_item_scene = preload("res://View/Menu/shop_window/card_item.tscn")
var upgrade_item_scene = preload("res://View/Menu/shop_window/upgrade_item.tscn")

func _ready() -> void:
	shop_manager = GameManager.shop_manager
	cards_to_buy = GameManager.card_manager.get_random_cards_by_deck(GameManager.battle_state.player_stats.char_id, shop_manager.nb_of_shop_card)
	upgrades_to_buy = GameManager.card_manager.get_random_upgrades(shop_manager.nb_of_upgrades)
	print(upgrades_to_buy)
	display_cards_to_buy()
	display_card_upgrades()
	
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
	for upgrade in upgrades_to_buy:
		var upgrade_scene = upgrade_item_scene.instantiate()
		upgrade_scene.upgrade = upgrade
		upgrades_container.add_child(upgrade_scene)
		
func buy_card(card : CardData):
	pass
func buy_upgrade(upgrade : CardUpgradeData):
	pass
