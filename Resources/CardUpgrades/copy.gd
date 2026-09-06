extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.COPY
	icon_color = Color(0.325, 0.471, 0.655, 1.0)

func apply_upgrade(card : CardData):
	super(card)
	var duplicated_card = card.duplicate(true)
	GameManager.battle_state.player_deck.append(duplicated_card.card_data)
