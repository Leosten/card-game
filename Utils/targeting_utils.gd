class_name TargetingUtils

static func get_monster_action_affected_cells(origin_cell : Vector2i, action : MonsterAction) -> Array[Vector2i]:
	var absolute_cells: Array[Vector2i] = []
	var origin_offset: Vector2i = action.area_origin

	for offset in action.area_pattern:
		var relative: Vector2i = offset - origin_offset
		relative.x = -relative.x # mirror horizontally so the pattern points left
		absolute_cells.append(origin_cell + relative)
	return absolute_cells

# Returns all absolute grid cells affected when aiming at hover_origin
static func get_card_affected_cells(origin_cell: Vector2i, card: CardData) -> Array[Vector2i]:
	var absolute_cells: Array[Vector2i] = []
	var origin_offset: Vector2i = card.area_origin

	for offset in card.area_pattern:
		var target_cell: Vector2i = origin_cell + (offset - origin_offset)
		absolute_cells.append(target_cell)
	return absolute_cells

static func draw_mouse_card_targeting_line(targeting_line : Line2D, card : Card, mouse_pos: Vector2i):
	# 1. Start point = Center of card UI element
	var start_pos: Vector2i = card.global_position + (card.size * 0.5)

	var overlay_tilemap : TileMapLayer = GameManager.grid_manager.target_highlight_grid
	var target_bounds : Rect2i = GameManager.grid_manager.get_card_target_bounds(card.card_data)
	# 2. Get target cell from current mouse cursor position
	var local_mouse: Vector2i = overlay_tilemap.to_local(mouse_pos)
	var target_cell: Vector2i = overlay_tilemap.local_to_map(local_mouse)

	var end_pos: Vector2i

	if target_bounds.has_point(target_cell):
	# Valid arena tile -> Snap to grid center
		var cell_local_center: Vector2i = overlay_tilemap.map_to_local(target_cell)
		end_pos = overlay_tilemap.to_global(cell_local_center)
	else:
	# Outside arena -> Fallback to raw mouse position
		end_pos = mouse_pos
	targeting_line.update_targeting_curve(start_pos, end_pos)
	GameManager.grid_manager.update_card_aoe_preview(target_cell, card.card_data, overlay_tilemap, target_bounds)

static func get_clicked_cell(target_grid, mouse_pos) -> Vector2i:
	var local_pos: Vector2i = target_grid.to_local(mouse_pos)
	var clicked_cell: Vector2i = target_grid.local_to_map(local_pos)
	return clicked_cell
