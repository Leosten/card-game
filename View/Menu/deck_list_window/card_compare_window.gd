extends Control

signal card_accepted
signal card_refused

@onready var first_card_container = %FirstCardContainer
@onready var preview_card_container = %SecondCardContainer

func _ready() -> void:
	pass

func _on_close_btn_pressed() -> void:
	card_refused.emit()
	self.queue_free()	

func _on_select_btn_pressed() -> void:
	card_accepted.emit()
	self.queue_free()

func set_cards(first_card_data : CardData, card_preview_data : CardData):
	var first_card : Card = GameManager.card_manager.instantiate_card_scene(first_card_data)
	first_card_container.add_child(first_card)
	first_card.update()

	var card_preview : Card = GameManager.card_manager.instantiate_card_scene(card_preview_data)
	preview_card_container.add_child(card_preview)
	card_preview.update()
