@abstract class_name CardUtils
extends Node

enum targets {ALLY, ENEMY, ALL_ENEMIES, SELF}
enum action_type {HEAL, DAMAGE, SHIELD, STATUS_EFFECTS, BUFFS}

static func hover_animation(card: Card) -> void:
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
	card.active_tween.tween_property(
		card, "position",
		Vector2(card.base_position.x, card.base_position.y - card.hover_size),
		0.2
	).set_ease(Tween.EASE_IN)

static func hover_back_animation(card: Card) -> void:
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
	card.active_tween.tween_property(
		card, "position",
		card.base_position,
		0.2
	).set_ease(Tween.EASE_OUT)

static func reposition_animation(card: Card, new_position : Vector2) -> void:
	if card.active_tween:
		card.active_tween.kill()
	card.active_tween = card.create_tween().set_trans(Tween.TRANS_LINEAR)
	card.active_tween.tween_property(
		card, "position",
		new_position,
		0.2
	).set_ease(Tween.EASE_IN)
	
static func find_card_by_position(
	player_hand : Array[CardData],
	card_position):
	for card in player_hand:
		if card.hand_position == card_position:
			return card
			
