class_name Card
extends Area2D

@export var cardHandPosition : int

func _ready() -> void:
	pass

func initCard(cardName, cardHandPos) -> void:
	cardHandPosition = cardHandPos
	$CardVisual/CardName.text = cardName

func _process(delta: float) -> void:
	pass
	#position = position.lerp(target_position, speed * delta)


func _on_mouse_entered() -> void:
	$AnimationPlayer.play("card_hover_animation")

#func _on_mouse_exited() -> void:
	#$AnimationPlayer.play("RESET")

func animation_left() -> void:
	$AnimationPlayer.play("card_stack_left")
	
