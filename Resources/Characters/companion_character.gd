class_name CompanionCharacter

extends AnimatableBody2D

var animating = false
@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var stats : CompanionStats

func init(stats_data : CompanionStats):
	stats = stats_data

func _process(_delta):
	if not animating:
		_animated_sprite.play("idle")
