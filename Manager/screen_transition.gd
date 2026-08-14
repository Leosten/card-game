# ScreenTransition.gd (Autoload Singleton)
extends CanvasLayer

var color_rect: ColorRect
var shader_mat: ShaderMaterial

func _ready() -> void:
	layer = 100
	
	# Create ColorRect covering full screen
	color_rect = ColorRect.new()
	color_rect.name = "WipeOverlay"
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Load and attach shader
	var shader = preload("res://View/Menu/wipe_transition.gdshader")
	shader_mat = ShaderMaterial.new()
	shader_mat.shader = shader
	color_rect.material = shader_mat
	
	# Start fully clear (progress = 0)
	shader_mat.set_shader_parameter("progress", 0.0)
	
	add_child(color_rect)


## Fast slash wipe RIGHT -> LEFT covering screen in black
func wipe_out(duration: float = 0.35) -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween = create_tween()
	tween.tween_property(shader_mat, "shader_parameter/progress", 1.0, duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
		
	await tween.finished

## Clears the black screen back to gameplay
func wipe_in(duration: float = 0.3) -> void:
	var tween = create_tween()
	tween.tween_property(shader_mat, "shader_parameter/progress", 0.0, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	await tween.finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
