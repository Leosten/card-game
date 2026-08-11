class_name TargetCharacter

extends AnimatableBody2D

var animating = false
@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var stats_window = $CharacterStatsWindow
var stats : Targetable

func connect_player_signals():
	stats.damage_taken.connect(on_damage_taken)
	stats.buffed.connect(on_buffed)
	stats.shielded.connect(on_shielded)

func _ready():
	stats_window = get_node('CharacterStatsWindow')
	stats_window.init_stats_window(stats)

func attack_animation():
	animating = true
	_animated_sprite.stop()
	if (_animated_sprite.sprite_frames.has_animation("attack")):
		_animated_sprite.play("attack")
	await _animated_sprite.animation_finished
	animating = false

func on_damage_taken(damage):
	animating = true
	_animated_sprite.stop()
	if (_animated_sprite.sprite_frames.has_animation("damage_taken")):
		_animated_sprite.play("damage_taken")
		await _animated_sprite.animation_finished
	animating = false

func on_buffed():
	pass

func on_shielded():
	print("has ben shielded")
	pass
