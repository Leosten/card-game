extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.PURIFY
	icon_color = Color(0.475, 0.894, 1.0, 1.0)
	
func apply_card_upgrade(card : CardData):
	card.cost -= value
