class_name ShopManager
extends Node

var shop_scene

var nb_of_shop_card = 5
var nb_of_upgrades = 2
var nb_shops_visited = 0
var nb_card_remove_used = 0
var card_remove_base_price = 25
var upgrade_base_price = 75

const TIER_PRICES: Dictionary = {
	CardUtils.tier.COMMON: Vector2i(25, 45),
	CardUtils.tier.PURPLE: Vector2i(50, 85),
	CardUtils.tier.GOLD: Vector2i(100, 160),
}

func _init():
	Events.shop_start.connect(_on_shop_start)

func _on_shop_start():
	load_shop_scene()
	set_shop_battle_position()

func get_card_price(card : CardData):
	if not TIER_PRICES.has(card.tier):
		return 50

	var price_range: Vector2i = TIER_PRICES[card.tier]
	
	var raw_price: int = randi_range(price_range.x, price_range.y)
	
	return raw_price

func get_remove_card_price():
	return min(card_remove_base_price * nb_card_remove_used, 150)

func load_shop_scene():
	print("Character number 0 scene loading")
	var shop = preload("res://View/Battle/shop_character/shop_character.tscn")
	
	if shop == null:
		printerr("Cannot load shop scene")
		return null
	shop_scene = shop.instantiate()

func set_shop_battle_position():
	var char_position := Vector2(
		GameManager.viewport_size.x - 700,
		GameManager.viewport_size.y - 800
	)
	shop_scene.position = char_position

func get_shop_scene():
	return shop_scene
