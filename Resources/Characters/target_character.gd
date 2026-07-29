class_name TargetCharacter

extends CharacterBody2D

var animating = false
@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func attack_animation():
	animating = true
	_animated_sprite.stop()
	_animated_sprite.play("attack")
	await _animated_sprite.animation_finished
	animating = false
