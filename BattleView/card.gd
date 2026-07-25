class_name Card
extends Area2D

@export var cardHandPosition : int
@export var card_data : CardData

var hover_size : int = 250
var hovered : bool = false
var anim = false
var selected : bool = false

func _ready() -> void:
	pass

func init_card(cardHandPos, card_d) -> void:
	$CardVisual/CardPosLabel.text = cardHandPos
	$CardVisual/CardName.text = card_d.name
	$CardVisual/CardDescription.text = card_d.description
	card_data = card_d

func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	if (hovered == true):
		return
	anim = true
	hovering()
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - hover_size), 0.2).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "anim_complete"))
	tween.tween_callback(Callable(self, "hovering"))

func _on_mouse_exited() -> void:
	if (anim == true || hovered == false || selected == true) :
		return
	anim = true

	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(
		self, "position", 
		Vector2(self.position.x, self.position.y + hover_size), 0.5)
	tween.tween_callback(Callable(self, "anim_complete"))
	tween.tween_callback(Callable(self, "hovering_off"))

func animation_left() -> void:
	$AnimationPlayer.play("card_stack_left")

func hovering():
	hovered = true

func hovering_off():
	hovered = false

func anim_complete():
	anim = false
