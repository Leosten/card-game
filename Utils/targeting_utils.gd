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
