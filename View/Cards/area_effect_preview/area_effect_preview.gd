extends Control

var card_area_effect : Array[Vector2i] = []
var card_grid_target : CardUtils.grid_target = CardUtils.grid_target.PLAYER
@onready var preview_grid = %PreviewMapLayer
const PREVIEW_CENTER_CELL := Vector2i(2, 2)

func _ready() -> void:
	pass

func init(card_data: CardData):
	card_area_effect = card_data.area_pattern
	card_grid_target = card_data.grid_target
	_draw_area_preview()

func _draw_area_preview():
	if card_area_effect.is_empty():
		return
	var centered_cells := _center_pattern(card_area_effect)
	for cell in centered_cells:
		preview_grid.set_cell(cell, 1, Vector2i(0, 0), get_square_color())

func _center_pattern(pattern: Array[Vector2i]) -> Array[Vector2i]:
	var min_cell := pattern[0]
	var max_cell := pattern[0]
	for cell in pattern:
		min_cell.x = min(min_cell.x, cell.x)
		min_cell.y = min(min_cell.y, cell.y)
		max_cell.x = max(max_cell.x, cell.x)
		max_cell.y = max(max_cell.y, cell.y)

	var bbox_center := Vector2i(
		floori((min_cell.x + max_cell.x) / 2.0),
		floori((min_cell.y + max_cell.y) / 2.0)
	)
	var shift := PREVIEW_CENTER_CELL - bbox_center

	var centered: Array[Vector2i] = []
	for cell in pattern:
		centered.append(cell + shift)
	return centered

func get_square_color():
	match card_grid_target:
		CardUtils.grid_target.PLAYER:
			return 5
		CardUtils.grid_target.ENEMY:
			return 4
