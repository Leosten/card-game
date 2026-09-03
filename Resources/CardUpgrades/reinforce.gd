extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.REINFORCE

func apply_upgrade(card : CardData):
	if (card.damage > 0):
		card.damage += value
	if (card.shield > 0):
		card.shield += value
	if (card.heal > 0):
		card.heal += value
