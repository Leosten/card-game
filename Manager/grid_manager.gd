class_name GridManager
extends Node
const MAX_ROW = 3
const ARENA_BOUNDS: Rect2i = Rect2i(0, 0, 8, 4)
const PLAYER_TERRITORY: Rect2i = Rect2i(0, 0, 4, 4)
const ENEMY_TERRITORY: Rect2i = Rect2i(4, 0, 4, 4)

const SQUARE_SOURCE_ID := 1
const PLAYER_SQUARE_ALT_ID := 1
const ENEMY_SQUARE_ALT_ID := 2
const HIGHLIGHT_SQUARE_ALT_ID := 3

var main_grid : TileMapLayer
var target_highlight_grid : TileMapLayer
var enemy_action_highlight_grid : TileMapLayer

var cell_data_map: Dictionary = {}

func draw_battlefield_squares() -> void:
	main_grid.clear()
	for y in range(ARENA_BOUNDS.position.y, ARENA_BOUNDS.end.y):
		for x in range(ARENA_BOUNDS.position.x, ARENA_BOUNDS.end.x):
			var cell := Vector2i(x, y)
			var alt_id := PLAYER_SQUARE_ALT_ID
			if ENEMY_TERRITORY.has_point(cell):
				alt_id = ENEMY_SQUARE_ALT_ID
			main_grid.set_cell(cell, SQUARE_SOURCE_ID, Vector2i.ZERO, alt_id)

func set_monster_grid_position(unit: TargetCharacter, col, row):
	var cell_coor := Vector2i(
		ENEMY_TERRITORY.position.x + col,
		ENEMY_TERRITORY.position.y + row
	)
	if not ENEMY_TERRITORY.has_point(cell_coor):
		push_warning("set_monster_grid_position: cell %s is outside ENEMY_TERRITORY" % str(cell_coor))
		return
	place_unit_on_tile(unit, main_grid, cell_coor)

func place_unit_on_tile(unit: TargetCharacter, tile_map : TileMapLayer, tile_coords: Vector2i) -> void:
	# 1. Get local position of tile center
	var local_pos: Vector2 = tile_map.map_to_local(tile_coords)
	# 2. Convert to global screen space and apply
	unit.global_position = tile_map.to_global(local_pos)
	unit.stats.grid_position = tile_coords
	set_cell_data(tile_coords, "target_character", unit)

func set_cell_data(cell: Vector2i, key: String, value: Variant) -> void:
	if not cell_data_map.has(cell):
		cell_data_map[cell] = {}
		
	cell_data_map[cell][key] = value

# Get custom data at a coordinate
func get_cell_data(cell: Vector2i, key: String, default_value: Variant = null) -> Variant:
	if cell_data_map.has(cell) and cell_data_map[cell].has(key):
		return cell_data_map[cell][key]
	return default_value

func inspect_tile_at(tile_map_layer : TileMapLayer, cell_coords: Vector2i) -> void:
	# Get the TileData resource for the specific cell
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(cell_coords)
	
	if tile_data == null:
		print("Cell is empty (no tile placed)!")
		return
	# Access custom data layers defined in your TileSet resource
	var is_walkable: bool = tile_data.get_custom_data("is_walkable")
	var move_cost: int = tile_data.get_custom_data("move_cost")
	print("Tile at ", cell_coords, " | Walkable: ", is_walkable, " | Cost: ", move_cost)

static func is_cell_empty(map_layer: TileMapLayer, cell_coords: Vector2i):
	# 1. Ensure tile exists on base map
	if map_layer.get_cell_tile_data(cell_coords) == null:
		return false
	if map_layer.get_cell_tile_data(cell_coords).occupier != null:
		return false
	# 2. Check if cell is recorded in dictionary
	#return not occupied_cells.has(cell_coords) or occupied_cells[cell_coords] == null

func get_card_target_bounds(card : CardData) -> Rect2i:
	match card.grid_target:
		CardUtils.grid_target.ENEMY:
			return ENEMY_TERRITORY
		CardUtils.grid_target.PLAYER:
			return PLAYER_TERRITORY
		_:
			return ARENA_BOUNDS

# Returns all absolute grid cells affected when aiming at hover_origin
func get_affected_cells(hover_origin: Vector2i, card: CardData, target_grid : TileMapLayer) -> Array[Vector2i]:
	var absolute_cells: Array[Vector2i] = []
	var origin_offset: Vector2i = card.area_origin

	for offset in card.area_pattern:
		var target_cell: Vector2i = hover_origin + (offset - origin_offset)
		absolute_cells.append(target_cell)
			
	return absolute_cells

func update_card_aoe_preview(hover_origin: Vector2i, active_card: CardData, target_grid : TileMapLayer, target_bounds : Rect2i) -> void:
	target_grid.clear() # Clear previous frame highlights
	if active_card.area_pattern == null:
		return
	if not target_bounds.has_point(hover_origin):
		return
	# 1. Compute cells
	var target_cells: Array[Vector2i] = get_affected_cells(hover_origin, active_card, target_grid)
	
	# 2. Draw pattern on overlay layer
	for cell : Vector2i in target_cells:
		if not target_bounds.has_point(cell):
			continue
		target_grid.set_cell(cell, SQUARE_SOURCE_ID, Vector2i.ZERO, 3)

func stop_aoe_preview():
	target_highlight_grid.clear()

func get_affected_targets(hover_origin: Vector2i, card: CardData) -> Array:
	var target_cells: Array[Vector2i] = get_affected_cells(hover_origin, card, main_grid)
	var targets = []
	for cell in target_cells:
		if cell_data_map.has(cell):
			var target_unit: TargetCharacter = get_cell_data(cell, "target_character")
			print ("TARGET unit found : ", target_unit.name)
			targets.append(target_unit)
	return targets

func is_valid_target_cell() -> bool:
	return true
