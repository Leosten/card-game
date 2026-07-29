class_name Card
extends Area2D

signal clicked(card_data: CardData)
signal hovered(card_data: CardData)
signal hovered_out(card_data: CardData)
@export var hand_position : int
@export var card_data : CardData

var hover_size : int = 120
var hovering : bool = false
var selected : bool = false
var base_position: Vector2
var active_tween: Tween

func _ready() -> void:
	pass

func init_card(hand_position, card_d : CardData, hud_position : Vector2) -> void:
	position = hud_position
	base_position = position
	z_index = hand_position + 1
	update(card_d)
	#card_data = card_d

func update(card_d : CardData):
	hand_position = card_d.hand_position
	$CardVisual/CardPosLabel.text = str(hand_position)
	$CardVisual/CardName.text = card_d.name
	$CardVisual/CardDescription.text = card_d.description.format({
		"dmg":str(card_d.damage),
		"heal":str(card_d.heal),
		"shield":str(card_d.shield)
	})
	$CardVisual/CostLabel.text = str(card_d.cost)
	card_data = card_d

func update_cost_label(current_mana):
	var color = Color(0.0, 0.0, 0.0, 1.0)
	if current_mana >= card_data.cost :
		color = Color(0.149, 0.959, 0.792, 1.0)
	$CardVisual/CostLabel.label_settings.font_color = color

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
