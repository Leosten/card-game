extends Control

var upgrade : CardUpgradeData
@onready var upgrade_name = %UpgradeName
@onready var upgrade_description = %UpgradeDescription
@onready var upgrade_price = %UpgradePrice
@onready var upgrade_icon = %UpgradeIcon

func _ready() -> void:
	set_data()

func set_data():
	upgrade_name.text = upgrade.name
	upgrade_description.text = upgrade.description
	upgrade_price.text = str(100)
	upgrade_icon.texture = upgrade.icon
	#upgrade_icon.modulate(upgrade.icon_color)
