extends Node2D

const CARD_SCENE := preload("res://Card.tscn")

@export var default_nb_of_cards := 6
@export var card_overlap := 18.0
@export var bottom_margin := 32.0
@export var side_margin := 25.0
@export var fan_height := 90.0
@export var max_fan_angle := 15.0

var cards: Array[Card] = []
var hovered_card: Card

func _ready() -> void:
	_spawn_starting_hand()

func _process(_delta: float) -> void:
	_update_hovered_card()

func _spawn_starting_hand() -> void:
	if default_nb_of_cards <= 0:
		return

	var card_bounds := _get_card_bounds()
	var viewport_size := get_viewport_rect().size
	var card_width: float = card_bounds.size.x
	var gap_count: int = max(default_nb_of_cards - 1, 0)
	var preferred_step: float = max(card_width - card_overlap, 1.0)
	var available_width: float = max(viewport_size.x - side_margin * 2.0, card_width)
	var step: float = preferred_step

	if gap_count > 0:
		var max_step_that_fits: float = (available_width - card_width) / gap_count
		step = min(preferred_step, max_step_that_fits)

	var total_width: float = card_width + gap_count * step
	var group_left: float = max((viewport_size.x - total_width) * 0.5, side_margin)
	var bottom_edge: float = viewport_size.y - bottom_margin
	var top_y: float = bottom_edge - card_bounds.position.y - card_bounds.size.y
	var center_index: float = gap_count * 0.5

	for existing_card in cards:
		existing_card.queue_free()
	cards.clear()
	hovered_card = null

	for index in range(default_nb_of_cards):
		var card := CARD_SCENE.instantiate() as Card
		var distance_from_center: float = 0.0
		if gap_count > 0:
			distance_from_center = (index - center_index) / center_index

		var arc_weight: float = 1.0 - distance_from_center * distance_from_center
		card.position = Vector2(
			group_left - card_bounds.position.x + index * step,
			top_y - arc_weight * fan_height
		)
		card.rotation = deg_to_rad(distance_from_center * max_fan_angle)
		card.z_index = index
		add_child(card)
		cards.append(card)

func _update_hovered_card() -> void:
	var mouse_position := get_global_mouse_position()
	var next_hovered_card: Card = null

	for card in cards:
		if not card.contains_global_point(mouse_position):
			continue
		if next_hovered_card == null or card.get_hover_order() > next_hovered_card.get_hover_order():
			next_hovered_card = card

	if hovered_card == next_hovered_card:
		return

	if hovered_card != null:
		hovered_card.set_hovered(false)

	hovered_card = next_hovered_card

	if hovered_card != null:
		hovered_card.set_hovered(true)

func _get_card_bounds() -> Rect2:
	var preview_card := CARD_SCENE.instantiate() as Area2D
	var collision_shape := preview_card.get_node_or_null("CollisionShape2D") as CollisionShape2D

	if collision_shape and collision_shape.shape is RectangleShape2D:
		var rectangle := collision_shape.shape as RectangleShape2D
		return Rect2(collision_shape.position - rectangle.size * 0.5, rectangle.size)

	var polygon := preview_card.get_node_or_null("Polygon2D") as Polygon2D
	if polygon and polygon.polygon.size() > 0:
		return _get_polygon_bounds(polygon.polygon, polygon.position)

	return Rect2(Vector2(-135.5, -194.0), Vector2(271.0, 388.0))

func _get_polygon_bounds(points: PackedVector2Array, offset: Vector2) -> Rect2:
	var bounds := Rect2(points[0] + offset, Vector2.ZERO)

	for point in points:
		bounds = bounds.expand(point + offset)

	return bounds
