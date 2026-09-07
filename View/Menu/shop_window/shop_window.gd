extends Control

var shop_manager : ShopManager
var cards_to_buy: Array[CardData]
var upgrades_to_buy: Array[CardUpgradeData]

@onready var cards_container = %CardsContainer
@onready var upgrades_container = %UpgradesContainer
@onready var remove_container = %RemoveCardContainer
@onready var remove_card_btn = %RemoveCardBtn
var remove_used = false

var card_item_scene = preload("res://View/Menu/shop_window/card_item.tscn")
var upgrade_item_scene = preload("res://View/Menu/shop_window/upgrade_item.tscn")

func _ready() -> void:
	shop_manager = GameManager.shop_manager
	cards_to_buy = GameManager.card_manager.get_random_cards_by_deck(GameManager.battle_state.player_stats.char_id, shop_manager.nb_of_shop_card)
	upgrades_to_buy = GameManager.card_manager.get_random_upgrades(shop_manager.nb_of_upgrades)
	Events.card_upgraded.connect(_on_card_upgraded)
	Events.card_removed.connect(_on_card_removed)
	
	print(upgrades_to_buy)
	display_cards_to_buy()
	display_card_upgrades()

func display_cards_to_buy():
	for card_data in cards_to_buy:
		var card : Card = GameManager.card_manager.instantiate_card_scene(card_data)
		var card_item = card_item_scene.instantiate()
		card_item.init(card, shop_manager.get_card_price(card_data))
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card_item.clicked.connect(_on_card_item_clicked)
		cards_container.add_child(card_item)

func display_card_upgrades():
	for upgrade in upgrades_to_buy:
		var upgrade_scene = upgrade_item_scene.instantiate()
		upgrade_scene.upgrade = upgrade
		upgrade_scene.clicked.connect(_on_upgrade_clicked)
		upgrades_container.add_child(upgrade_scene)

func _on_card_item_clicked(card_item : CardItem):
	buy_card(card_item)

func buy_card(card_item : CardItem):
	if card_item.is_sold == true:
		return
	var current_gold = GameManager.battle_state.player_stats.gold
	
	if current_gold >= card_item.price:
		#todo : visual and sound fx
		card_item.sold_card()
		GameManager.battle_state.player_deck.append(card_item.card_display.card_data.duplicate())
		GameManager.battle_state.player_stats.gold -= card_item.price
		print("card bought")
		return
	print("not enough money")

func _on_upgrade_clicked(upgrade_item : UpgradeItem):
	if upgrade_item.is_sold == true:
		return
	var current_gold = GameManager.battle_state.player_stats.gold
	if current_gold >= upgrade_item.price:
		Events.request_window_open.emit("deck", {
			"selection": true, 
			"selection_type": CardUtils.card_selection_types.UPGRADE,
			"upgrade": upgrade_item
		})
		return
	print("not enough money")

func _on_card_upgraded(upgrade_item):
	#todo : audio sfx
	GameManager.battle_state.player_stats.gold -= upgrade_item.price
	upgrade_item.sold()
	
func _on_card_removed():
	GameManager.battle_state.player_stats.gold -= shop_manager.card_remove_base_price
	shop_manager.nb_card_remove_used += 1
	remove_used = true
	remove_card_btn.disabled = true
	remove_container.modulate = Color(0.469, 0.469, 0.469, 1.0)
	
func _on_card_hovered(card : Card):
	CardAnimationManager.zoom_in(card)

func _on_card_hovered_out(card : Card):
	CardAnimationManager.zoom_out(card)

func _on_ignore_button_pressed() -> void:
	self.visible = false

func _on_remove_card_btn_pressed() -> void:
	if remove_used == true:
		return
	Events.request_window_open.emit("deck", {"selection": true, "selection_type": CardUtils.card_selection_types.REMOVE})
	
