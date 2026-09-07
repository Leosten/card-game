extends CardUpgradeData

func _init():
	type = CardUtils.card_upgrades_types.REINFORCE
	icon_color = Color(0.741, 0.318, 0.427, 1.0)
	value = randi_range(10, 20)

func apply_upgrade(card : CardData):
	super(card)
	card.upgrade()
	#if (card.damage > 0):
		#card.damage += value
	#if (card.shield > 0):
		#card.shield += value
	#if (card.heal > 0):
		#card.heal += value
