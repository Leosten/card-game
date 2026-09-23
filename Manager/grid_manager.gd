class_name GridManager
extends Node

const MAX_ROW := 3
const MAX_COL := 3
const ARENA_BOUNDS: Rect2i = Rect2i(0, 0, 4, 4)

var player_grid : TileMapLayer
var enemy_grid : TileMapLayer
var player_highlight_grid : TileMapLayer
var enemy_highlight_grid : TileMapLayer
var enemy_occupied_cells: = []

func get_square_scene():
	pass

func get_grid_scene():
	pass

func set_monster_grid_position(unit: TargetCharacter, col, row):
	var cell_coor = Vector2(col, row)
	place_unit_on_tile(unit, enemy_grid, cell_coor)
	enemy_occupied_cells.append(cell_coor)
	
func place_unit_on_tile(unit: TargetCharacter, tile_map : TileMapLayer, tile_coords: Vector2i) -> void:
	# 1. Get local position of tile center
	var local_pos: Vector2 = tile_map.map_to_local(tile_coords)
	# 2. Convert to global screen space and apply
	unit.global_position = tile_map.to_global(local_pos)
	unit.stats.grid_position = tile_coords
	#tile_map.get_cell_tile_data(tile_coords).occupier = unit

func inspect_tile_at(tile_map_layer : TileMapLayer,cell_coords: Vector2i) -> void:
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

func get_card_target_highlight_grid(card : CardData) -> TileMapLayer:
	match card.grid_target:
		CardUtils.grid_target.PLAYER:
			return player_highlight_grid
		CardUtils.grid_target.ENEMY:
			return enemy_highlight_grid
		_:
			return enemy_highlight_grid

func get_card_target_active_grid(card : CardData) -> TileMapLayer:
	match card.grid_target:
		CardUtils.grid_target.PLAYER:
			return player_grid
		CardUtils.grid_target.ENEMY:
			return enemy_grid
		_:
			return enemy_grid

const OVERLAY_SOURCE_ID: int = 1
const AOE_HIGHLIGHT_ATLAS: Vector2i = Vector2i(0, 0) # Red / Blue highlight tile

# Returns all absolute grid cells affected when aiming at hover_origin
func get_affected_cells(hover_origin: Vector2i, card: CardData, target_grid : TileMapLayer) -> Array[Vector2i]:
	var absolute_cells: Array[Vector2i] = []
	var origin_offset: Vector2i = card.area_origin

	for offset in card.area_pattern:
		var target_cell: Vector2i = hover_origin + (offset - origin_offset)
		absolute_cells.append(target_cell)
			
	return absolute_cells

func update_card_aoe_preview(hover_origin: Vector2i, active_card: CardData, target_grid : TileMapLayer) -> void:
	target_grid.clear() # Clear previous frame highlights
	if active_card.area_pattern == null:
		return
	if not ARENA_BOUNDS.has_point(hover_origin):
		return
	# 1. Compute cells
	var target_cells: Array[Vector2i] = get_affected_cells(hover_origin, active_card, target_grid)
	
	# 2. Draw pattern on overlay layer
	for cell : Vector2i in target_cells:
		if not ARENA_BOUNDS.has_point(cell):
			continue
		target_grid.set_cell(cell, OVERLAY_SOURCE_ID, AOE_HIGHLIGHT_ATLAS, 3)

func stop_aoe_preview():
	enemy_highlight_grid.clear()
	player_highlight_grid.clear()

func play_card_at(hover_origin: Vector2i, card: CardData, grid_manager: GridManager,  target_grid : TileMapLayer) -> void:
	var target_cells: Array[Vector2i] = get_affected_cells(hover_origin, card, target_grid)
	
	for cell in target_cells:
		if grid_manager.occupied_cells.has(cell):
			var target_unit: TargetCharacter = enemy_grid.occupied_cells[cell].occupier
			target_unit.take_damage(card.damage_amount)
			
	target_grid.clear()
