class_name Card
extends Control

signal clicked(card_data: CardData)
signal hovered(card_data: CardData)
signal hovered_out(card_data: CardData)
@export var hand_position : int
@export var card_data : CardData

@onready var card_name_label: Label = $CardLayout/TopBar/Name
@onready var cost_label: Label = $CardLayout/TopBar/CostContainer/ManaCost
@onready var portrait: TextureRect = $CardLayout/ArtContainer/Portrait
@onready var description_label: RichTextLabel = $CardLayout/DescriptionContainer/Description
@onready var card_type_label: Label = $CardLayout/BottomBar/CardType

var hover_size : int = 120
var hovering : bool = false
var selected : bool = false
var base_position: Vector2
var active_tween: Tween

func _ready() -> void:
	update(card_data)
	pass
 
func init_card(hand_position, card_d : CardData, hud_position : Vector2) -> void:
	position = hud_position
	base_position = position
	z_index = hand_position + 1
	card_data = card_d

func update(card_d : CardData):
	hand_position = card_d.hand_position
	card_name_label.text = card_d.name
	description_label.text = card_d.description.format({
		"damage":str(card_d.damage),
		"heal":str(card_d.heal),
		"shield":str(card_d.shield),
	})
	cost_label.text = str(card_d.cost)
	card_data = card_d

func update_cost_label(current_mana):
	var color = Color(0.0, 0.0, 0.0, 1.0)
	if current_mana >= card_data.cost :
		color = Color(0.149, 0.959, 0.792, 1.0)
	cost_label.label_settings.font_color = color

func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	print("Hovered !")
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
	clicked.emit(card_data)
