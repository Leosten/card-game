class_name Card
extends Area2D

@export var cardHandPosition : int
@export var card_data : CardData

var hover_size : int = 250
var hovered : bool = false
var anim = false

func _ready() -> void:
	pass

func init_card(cardHandPos, card_data) -> void:
	$CardVisual/CardPosLabel.text = cardHandPos
	$CardVisual/CardName.text = card_data.name
	$CardVisual/CardDescription.text = card_data.description
	card_data = card_data

func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	if (hovered == true):
		return
	anim = true
	hovering()
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	#$AnimationPlayer.play("card_hover_animation")
	tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - hover_size), 0.2).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "anim_complete"))
	tween.tween_callback(Callable(self, "hovering"))

func _on_mouse_exited() -> void:
	#$AnimationPlayer.play("RESET")
	#hovered = false;
	if (anim == true || hovered == false) :
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
