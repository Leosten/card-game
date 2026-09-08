extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.RALLY
	icon_color = Color(0.149, 0.961, 0.792, 1.0)

func apply_upgrade(card : CardData):
	super(card)
	card.rally = true
	card.description += ". [color={shield_color}]Rally[/color]."
