extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if _animated_sprite.animation.contains("idle"):
		_animated_sprite.play("idle")
