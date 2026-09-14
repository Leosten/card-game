extends Control

var card_area_effect : Array[Vector2i] = []
var card_grid_target : CardUtils.grid_target = CardUtils.grid_target.PLAYER
@onready var preview_grid = %PreviewMapLayer

func _ready() -> void:
	pass

func init(card_data: CardData):
	card_area_effect = card_data.area_pattern
	card_grid_target = card_data.grid_target
	_draw_area_preview()
func _draw_area_preview():
	if card_area_effect.is_empty():
		return
	for cell in card_area_effect:
		preview_grid.set_cell(cell, 1, Vector2i(0,0), get_square_color())

func get_square_color():
	match card_grid_target:
		CardUtils.grid_target.PLAYER:
			return 5
		CardUtils.grid_target.ENEMY:
			return 4
