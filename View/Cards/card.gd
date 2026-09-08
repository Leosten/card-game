class_name Card
extends Control

signal clicked(card: Card)
signal hovered(card: Card)
signal hovered_out(card: Card)
signal used(card: Card)
signal exhausted(card: Card)

@export var hand_position : int
@export var card_data : CardData

@onready var card_name_label: Label = %Name
@onready var cost_label: Label = %ManaCost
@onready var portrait: TextureRect = %Portrait
@onready var description_label: RichTextLabel = %Description
@onready var background: TextureRect = %Background
@onready var upgrades_container = %UpgradesIcons

var hover_size : int = 120
var hovering : bool = false
var selected : bool = false
var base_position: Vector2
var active_tween: Tween
var green_color = "26f5caff"

var fire_color = "bd516dff"
var ice_color = "5378a7ff"
var wind_color = "a9d18bff"
var shield_color = "81c0c6ff"
var disabled_color = "797979ff"

func _ready() -> void:
	description_label.bbcode_enabled = true
	card_data.data_changed.connect(update)
	card_data.used.connect(on_card_used)
	card_data.exhausted.connect(on_card_exhausted)
	update_upgrades()

func on_card_used():
	used.emit(self)

func on_card_exhausted():
	exhausted.emit(self)

func init_position(hand_position, hud_position : Vector2):
	position = hud_position
	base_position = position
	z_index = hand_position + 1

func init_data(card_d : CardData) -> void:
	card_data = card_d

func update():
	hand_position = card_data.hand_position
	portrait.texture = card_data.artwork
	var bg_texture = GameManager.card_manager.get_card_background(card_data.type)
	background.texture = bg_texture
	update_text()

func update_text():
	card_name_label.text = card_data.name
	description_label.text = card_data.description.format({
		"damage":str(card_data.damage),
		"heal":str(card_data.heal),
		"shield":str(card_data.shield),
		"draw_value":str(card_data.draw_value),
		"channel_remove_value":str(card_data.channel_remove_value),
		"channel_add_value":str(card_data.channel_add_value),
		"value_color": green_color,
		"shield_color": shield_color,
		"fire_color": fire_color,
		"ice_color": ice_color,
		"wind_color": wind_color,
		"status_stacks":str(card_data.status_stacks),
	})
	# TODO : buffs and status values in description
	cost_label.text = str(card_data.cost)

func update_upgrades():
	if card_data.upgrades.is_empty() == true:
		return
	for upgrade : CardUpgradeData in card_data.upgrades:
		var card_upgrade = GameManager.card_manager.get_card_upgrade_scene(upgrade)
		upgrades_container.add_child(card_upgrade)
		card_upgrade.update()

func update_cost_label(current_mana):
	var color = Color(disabled_color)
	if current_mana >= card_data.cost :
		color = Color(green_color)
	cost_label.label_settings.font_color = color

func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	hovered.emit(self)

func _on_mouse_exited() -> void:
	hovered_out.emit(self)

func _on_card_button_pressed() -> void:
	clicked.emit(self)
