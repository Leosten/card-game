class_name UpgradeItem
extends Control

signal clicked(upgrade_item)

@onready var upgrade_name = %UpgradeName
@onready var upgrade_description = %UpgradeDescription
@onready var upgrade_price = %UpgradePrice
@onready var upgrade_icon = %UpgradeIcon
@onready var btn_container = %ButtonContainer
#@onready var glow: UIGlow = %UIGlow

var price := 0
var upgrade : CardUpgradeData
var is_sold := false

func _ready() -> void:
	price = GameManager.shop_manager.upgrade_base_price
	set_data()

func set_data():
	upgrade_name.text = upgrade.name
	upgrade_description.text = upgrade.description
	upgrade_price.text = str(price)
	upgrade_icon.texture = upgrade.icon
	upgrade_icon.modulate = upgrade.icon_color

func _on_upgrade_button_pressed() -> void:
	print("upgrd btn pressed")
	clicked.emit(self)

func sold():
	is_sold = true
	btn_container.modulate = Color(0.456, 0.456, 0.456, 1.0)
