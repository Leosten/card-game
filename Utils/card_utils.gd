@abstract class_name CardUtils
extends Node

enum targets {ALLY, ENEMY, ALL_ENEMIES, SELF}
enum action_type {HEAL, DAMAGE, SHIELD, STATUS_EFFECTS, BUFFS, CHANNEL_ADD, CHANNEL_REMOVE, CHANNEL_CLEAR, CHANNEL_USE, DRAW}
enum magic_type {FIRE, WIND, ICE}
enum tier {COMMON, PURPLE, GOLD, STARTER}
enum card_type {ATTACK, MAGIC, BUFF, ELEMENTAL}

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

static func init_card_position(card_hud_size, max_nb_of_cards, player_draw_value, card_size, margin_between_cards, left_margin, bottom_margin) -> Array[Area2D]:
	var card_hand_positions : Array[Area2D]= []
	#print("card hand position " , card_hud_size.x , " " , card_hud_size.y)
	for card_pos_index in range(max_nb_of_cards):
		var card_area = Area2D.new()
		var card_position := Vector2(
			(card_hud_size.x + left_margin + (card_pos_index * card_size) + (card_pos_index * margin_between_cards)) ,
			card_hud_size.y - bottom_margin
		)
		card_area.position = card_position
		print("card ",card_pos_index ," position " , card_position.x , " " , card_position.y)
		
		card_hand_positions.append(card_area)
	print("card positions init ")
	print(card_hand_positions)
	return card_hand_positions
	
static func orbs_not_empty(orbs : Array[CardUtils.magic_type])-> bool:
	if orbs.size() <= 0:
		return false
	return true
