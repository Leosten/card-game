class_name CardItem
extends Control

@onready var card_container = %CardContainer
@onready var price_display = %Price

var price := 0
var card_display : Card = null

func init(card : Card, calculated_price : int) -> void:
	card_display = card
	price = calculated_price
	
func _ready() -> void:
	card_container.add_child(card_display)
	price_display.text = str(price)
	#card_display.update()
