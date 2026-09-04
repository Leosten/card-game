class_name CardUpgradeData

extends Resource

@export var name = ""
@export var value = 0
@export var icon : Texture2D = null
@export var type : CardUtils.card_upgrades_types
@export var icon_color : Color = Color()
@export var description : String = ""

func apply_upgrade(card : CardData):
	pass
