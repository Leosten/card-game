extends Monster

func _ready():
	$AnimatedSprite2D.flip_h = true

func _process(_delta):
	if _animated_sprite.animation.contains("idle"):
		_animated_sprite.play("idle")
