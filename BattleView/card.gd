class_name Card
extends Area2D

@export var cardHandPosition : int

func _ready() -> void:
	pass

func init_card(cardHandPos, card_data) -> void:
	$CardVisual/CardPosLabel.text = cardHandPos
	$CardVisual/CardName.text = card_data.name
	$CardVisual/CardDescription.text = card_data.description

func _process(delta: float) -> void:
	pass
	#position = position.lerp(target_position, speed * delta)


func _on_mouse_entered() -> void:
	$AnimationPlayer.play("card_hover_animation")

#func _on_mouse_exited() -> void:
	#$AnimationPlayer.play("RESET")

func animation_left() -> void:
	$AnimationPlayer.play("card_stack_left")
	
