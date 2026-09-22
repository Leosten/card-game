# TargetingLine2D.gd
class_name TargetingLine2D
extends Line2D

@export_range(10, 50) var point_count: int = 30
@export var curve_height_offset: float = -150.0 # Pulls control point upward for an arc

func _ready() -> void:
	visible = false

# Call this every frame while dragging or targeting with a card
func update_targeting_curve(start_pos: Vector2, target_pos: Vector2) -> void:
	visible = true
	clear_points()

	# Calculate Control Point (P1) to create the Bezier arc
	var mid_point: Vector2 = start_pos.lerp(target_pos, 0.5)
	# Pull control point upward (or outward) relative to distance
	var distance: float = start_pos.distance_to(target_pos)
	var control_point: Vector2 = mid_point + Vector2(0, curve_height_offset * (distance / 400.0))

	# Sample points along the quadratic Bezier curve
	for i in range(point_count + 1):
		var t: float = float(i) / float(point_count)
		var point_on_curve: Vector2 = _sample_quadratic_bezier(start_pos, control_point, target_pos, t)
		add_point(point_on_curve)

# Quadratic Bezier formula: B(t) = (1-t)² * P0 + 2(1-t)t * P1 + t² * P2
func _sample_quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	return q0.lerp(q1, t)

func hide_line() -> void:
	visible = false
	clear_points()
