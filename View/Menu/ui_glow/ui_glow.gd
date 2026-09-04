class_name UIGlow
extends ColorRect

@export var glow_color: Color = Color(1.0, 0.4, 0.0, 1.0):
	set(value):
		glow_color = value
		if is_node_ready():
			_update_material()

@export_range(0.0, 10.0) var flame_speed: float = 3.0:
	set(value):
		flame_speed = value
		if is_node_ready():
			_update_material()

func _ready() -> void:
	_update_material()

func set_flame_glow(color: Color, speed: float = 3.0) -> void:
	glow_color = color
	flame_speed = speed
	if is_node_ready():
		_update_material()

func _update_material() -> void:
	if material is ShaderMaterial:
		var mat = material as ShaderMaterial
		mat.set_shader_parameter("glow_color", glow_color)
		mat.set_shader_parameter("flame_speed", flame_speed)
