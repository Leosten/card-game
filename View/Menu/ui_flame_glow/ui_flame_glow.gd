class_name UIFlameGlow
extends Control

@onready var base_glow: Panel = $BaseGlow
@onready var flame_emitter: GPUParticles2D = $FlameEmitter

@export var flame_color: Color = Color(1.0, 0.4, 0.0, 1.0):
	set(value):
		flame_color = value
		if is_node_ready():
			_apply_colors()

func _ready() -> void:
	_apply_colors()

func set_flame_color(new_color: Color) -> void:
	flame_color = new_color

func _apply_colors() -> void:
	# 1. Update the square shadow base glow
	if base_glow:
		var style: StyleBoxFlat = base_glow.get_theme_stylebox("panel").duplicate()
		style.shadow_color = flame_color
		base_glow.add_theme_stylebox_override("panel", style)
	
	# 2. Modulate the particles (Tints both the particles and their gradient)
	if flame_emitter:
		flame_emitter.modulate = flame_color
