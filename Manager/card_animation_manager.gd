class_name CardAnimationManager
extends Node

var left_out_bounds = Vector2(-1000, 1250)

func clear_card_animation(displayed_hand: Array[Card]):
	var last_tween: Tween
	for card in displayed_hand:
		if card.active_tween:
			card.active_tween.kill()
		card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
		card.active_tween.tween_property(
			card, "position",
			left_out_bounds,
			0.2
		).set_ease(Tween.EASE_IN)
		last_tween = card.active_tween
	await last_tween.finished

func cards_appear_animation(displayed_hand: Array[Card], card_hand_positions : Array[Area2D]):
	var target_position = Vector2(-1000, 1250)
	var last_tween: Tween
	for card in displayed_hand:
		if card.active_tween:
			card.active_tween.kill()
		card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
		card.active_tween.tween_property(
			card, "position",
			target_position,
			0.4
		).set_ease(Tween.EASE_IN)
		last_tween = card.active_tween
	await last_tween.finished
