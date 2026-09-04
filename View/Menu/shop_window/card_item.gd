class_name CardItem
extends Control

signal clicked(card_item : CardItem)

@onready var card_container = %CardContainer
@onready var price_display = %Price
@onready var sold = %CardSold
var price := 0
var card_display : Card = null
var is_sold := false
func init(card : Card, calculated_price : int) -> void:
	card_display = card
	price = calculated_price

func _ready() -> void:
	card_container.add_child(card_display)
	price_display.text = str(price)
	card_display.update()
	card_display.clicked.connect(_on_clicked)
func sold_card():
	if not card_display == null:
		sold.visible = true
		card_display.visible = false


func _on_clicked(card: Card) -> void:
	print("card item clicked")
	clicked.emit(self)
