extends AnimatableBody2D

@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init_data(monster_data: MonsterData):
	$MonsterName.text = monster_data.name
	
func _process(_delta):
	if _animated_sprite.animation.contains("idle"):
		$AnimatedSprite2D.flip_h = true
		_animated_sprite.play("idle")
