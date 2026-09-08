extends Control

var card_upgrade : CardUpgradeData = null
@onready var icon : TextureRect = %Icon

func _ready() -> void:
	pass


func init(upgrade : CardUpgradeData):
	card_upgrade = upgrade

func update():
	var upgr_icon = card_upgrade.icon
	icon.texture = card_upgrade.icon
	icon.modulate = card_upgrade.icon_color
