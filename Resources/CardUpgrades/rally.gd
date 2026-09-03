extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.RALLY
	
func apply_upgrade(card : CardData):
	card.rally = true
