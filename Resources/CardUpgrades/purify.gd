extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.PURIFY

func apply_card_upgrade(card : CardData):
	card.cost -= value
