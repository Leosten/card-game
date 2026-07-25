extends Monster

func _process(_delta):
	if _animated_sprite.animation.contains("idle"):
		$AnimatedSprite2D.flip_h = true
		_animated_sprite.play("idle")
