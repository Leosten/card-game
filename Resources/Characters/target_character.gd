class_name TargetCharacter

extends Node2D

var animating = false
@onready var _skeleton_animation : AnimationPlayer = $Skeleton/AnimationPlayer
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
	_skeleton_animation.stop()
	if (_skeleton_animation.has_animation("attacking")):
		_skeleton_animation.play("attacking")
	await _skeleton_animation.animation_finished
	animating = false

func on_damage_taken(damage):
	Events.damage_taken.emit(damage, self.position)
	animating = true
	_skeleton_animation.stop()
	if (_skeleton_animation.has_animation("damage_taken")):
		_skeleton_animation.play("damage_taken")
		await _skeleton_animation.animation_finished
	animating = false
func on_buffed():
	pass

func on_shielded():
	print("has ben shielded")
	pass
