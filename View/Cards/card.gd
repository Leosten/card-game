class_name Card
extends Control

signal clicked(card: Card)
signal hovered(card: Card)
signal hovered_out(card: Card)
signal used(card: Card)
signal exhausted(card: Card)

@export var hand_position : int
@export var card_data : CardData

@onready var card_name_label: Label = $%Name
@onready var cost_label: Label = $%ManaCost
@onready var portrait: TextureRect = $%Portrait
@onready var description_label: RichTextLabel = $%Description
#@onready var card_type_label: Label = $%CardType

var hover_size : int = 120
var hovering : bool = false
var selected : bool = false
var base_position: Vector2
var active_tween: Tween

func _ready() -> void:
	card_data.data_changed.connect(update)
	card_data.used.connect(on_card_used)
	card_data.exhausted.connect(on_card_exhausted)

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
	var bg_texture = GameManager.card_manager.get_card_background(card_d.type)
	$Background.texture = bg_texture
	%Portrait.texture = card_d.artwork

func update():
	hand_position = card_data.hand_position
	update_text()

func update_text():
	$%PosLabel.text = str(card_data.hand_position)
	card_name_label.text = card_data.name
	description_label.text = card_data.description.format({
		"damage":str(card_data.damage),
		"heal":str(card_data.heal),
		"shield":str(card_data.shield),
		"draw_value":str(card_data.draw_value),
	})
	# TODO : buffs and status values in description
	cost_label.text = str(card_data.cost)

func update_cost_label(current_mana):
	var color = Color(0.0, 0.0, 0.0, 1.0)
	if current_mana >= card_data.cost :
		color = Color(0.149, 0.959, 0.792, 1.0)
	cost_label.label_settings.font_color = color

func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	hovered.emit(self)

func _on_mouse_exited() -> void:
	hovered_out.emit(self)

func animation_left() -> void:
	$AnimationPlayer.play("card_stack_left")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
		clicked.emit(hand_position)

func _on_card_button_pressed() -> void:
	clicked.emit(self)
