class_name CardAnimationManager
extends Node

var left_out_of_bounds = Vector2(-1000, 1250)
var right_out_of_bounds = Vector2(5000, 2000)
var viewport_size
var hud_size

func _ready():
	viewport_size = GameManager.get_viewport_size()

func clear_card_animation(displayed_hand: Array[Card]):
	if displayed_hand.is_empty():
		return
	var last_tween: Tween
	for card in displayed_hand:
		if card.active_tween:
			card.active_tween.kill()
		card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
		card.active_tween.tween_property(
			card, "position",
			left_out_of_bounds,
			0.2
		).set_ease(Tween.EASE_IN)
		last_tween = card.active_tween
	await last_tween.finished

func cards_appear_animation(displayed_hand: Array[Card], card_hand_positions : Array[Area2D]):
	if displayed_hand.is_empty():
		return
	var last_tween: Tween
	for card in displayed_hand:
		var target_position = card_hand_positions[card.hand_position].position
		if card.active_tween:
			card.active_tween.kill()
		card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
		card.active_tween.tween_property(card, "position", target_position, 0.5).set_ease(Tween.EASE_OUT)
		card.base_position = target_position
		last_tween = card.active_tween
	await last_tween.finished

func use_card_animation(card : Card):
	var target_position = Vector2(hud_size.size.x / 2, 0 - hud_size.size.y / 2)
	#print("target position ", hud_size.size.x , " ", hud_size.size.y)
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
	card.active_tween.tween_property(card, "position", target_position, 0.2).set_ease(Tween.EASE_IN)
	var zoom = Vector2(1.2, 1.2)
	card.active_tween.tween_property(card, "scale", zoom, 0.2).set_ease(Tween.EASE_IN)
	card.active_tween.tween_property(card, "position", left_out_of_bounds, 0.2).set_ease(Tween.EASE_OUT)

	await card.active_tween.finished

static func cannot_use_card_animation(card: Card):
	pass

func exhaust_card_animation(card: Card):
	use_card_animation(card)

static func reposition_animation(card: Card, new_position : Vector2) -> void:
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
	card.active_tween.tween_property(
		card, "position",
		new_position,
		0.2
	).set_ease(Tween.EASE_IN)

static func zoom_in(card : Card):
	card.pivot_offset = card.size / 2.0
	
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_QUAD)
	card.active_tween.tween_property(
		card, "scale",
		Vector2(1.2, 1.2),
		0.2
	).set_ease(Tween.EASE_OUT)
	
static func zoom_out(card : Card):
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
	card.active_tween.tween_property(
		card, "scale",
		Vector2(1.0, 1.0),
		0.2
	).set_ease(Tween.EASE_IN)

static func clean_tweens(cards : Array[Card]):
	for card in cards:
		card.active_tween.kill()
