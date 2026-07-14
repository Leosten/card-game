class_name Card
extends Area2D

@export var hover_offset := Vector2(0, -10)
@export var speed := 10.0
@export var hover_z_boost := 1000

var base_position: Vector2
var target_position: Vector2
var base_z_index: int
var is_hovered := false

func _ready() -> void:
	base_position = position
	target_position = position
	base_z_index = z_index
	
func initCard(cardName) -> void:
	$CardName.text = cardName;
	
func _process(delta: float) -> void:
	position = position.lerp(target_position, speed * delta)

func set_hovered(hovered: bool) -> void:
	if is_hovered == hovered:
		return

	is_hovered = hovered
	target_position = base_position
	if hovered:
		target_position += hover_offset
		z_index = base_z_index + hover_z_boost
	else:
		z_index = base_z_index

func contains_global_point(global_point: Vector2) -> bool:
	var collision_shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape == null or collision_shape.shape == null:
		return false

	var local_point := to_local(global_point) - collision_shape.position
	if collision_shape.shape is RectangleShape2D:
		var rectangle := collision_shape.shape as RectangleShape2D
		var half_size := rectangle.size * 0.5
		return absf(local_point.x) <= half_size.x and absf(local_point.y) <= half_size.y

	return false

func get_hover_order() -> int:
	return base_z_index
