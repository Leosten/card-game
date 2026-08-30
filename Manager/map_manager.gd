class_name MapManager

extends Node

var map: Array
var MAX_NB_OF_PATHS = 2
var MIN_NB_OF_PATHS = 1
var current_node : MapNodeData = null
var grid_width: int = 4
var grid_height: int = 13
var num_paths: int = 5 # Number of paths to trace from bottom to top

func generate_map():
	# 1. Initialize empty grid (4 columns x 12 floors)
	var grid: Array = []
	for y in range(grid_height):
		var row: Array = []
		for x in range(grid_width):
			row.append(null)
		grid.append(row)
		
	# 2. Trace paths from bottom (y = 0) to top (y = 11)
	for path_idx in range(num_paths):
		# Start at floor 0 (pick a column)
		var current_col: int = randi_range(0, grid_width - 1)
		
		# Instantiate or reuse node at floor 0
		if grid[0][current_col] == null:
			grid[0][current_col] = create_new_node(1)
			
			grid[0][current_col].grid_pos = Vector2i(current_col, 0)
			
		var current_node: MapNodeData = grid[0][current_col]
		
		# Trace up floor by floor
		for y in range(1, grid_height - 1):
			var next_y: int = y + 1
			
			# Pick available candidate columns on the next floor (-1, 0, or +1 offset)
			var valid_next_cols: Array[int] = []
			for col_offset in [-1, 0, 1]:
				var target_col: int = current_node.grid_pos.x + col_offset
				if target_col >= 0 and target_col < grid_width:
					# Rule: Check crossing paths before allowing step
					if not creates_cross_connection(grid, current_node.grid_pos, Vector2i(target_col, next_y)):
						valid_next_cols.append(target_col)
						
			# If no valid moves without crossing, lock to same column
			if valid_next_cols.is_empty():
				valid_next_cols.append(current_node.grid_pos.x)
				
			# Pick one random column from valid candidates
			var chosen_col: int = valid_next_cols.pick_random()
			
			# Instantiate target node if empty
			if grid[next_y][chosen_col] == null:
				grid[next_y][chosen_col] = create_new_node(next_y)
				grid[next_y][chosen_col].grid_pos = Vector2i(chosen_col, next_y)
				
			var target_node: MapNodeData = grid[next_y][chosen_col]
			
			# Connect current floor node to next floor node (avoid duplicate entries)
			if not current_node.next_nodes.has(target_node):
				current_node.next_nodes.append(target_node)
				
			# Move up to next node
			current_node = target_node
			
	map = grid
	print("MAP GENERATED")

func creates_cross_connection(grid: Array, from_pos: Vector2i, to_pos: Vector2i) -> bool:
	# Only checks diagonal steps (left or right)
	var col_diff: int = to_pos.x - from_pos.x
	if col_diff == 0:
		return false # Straight lines up never cross
		
	# Check adjacent origin node that could cause an X-crossing
	var neighbor_col: int = from_pos.x + col_diff
	if neighbor_col >= 0 and neighbor_col < grid_width:
		var neighbor_node: MapNodeData = grid[from_pos.y][neighbor_col]
		if neighbor_node != null:
			# If neighbor connects back to our target column, it creates an X-cross
			for target in neighbor_node.next_nodes:
				if target.grid_pos.x == from_pos.x:
					return true # Crossing detected!
	return false

func create_new_node(level) -> MapNodeData:
	var map_node = MapNodeData.new()
	var encounter_t = StageManager.get_stage_encounter_types(level).pick_random()
	map_node.encounter_type = encounter_t
	map_node.level = level
	map_node.background = GameManager.card_manager.get_large_card_background(encounter_t)
	return map_node

func is_node_selectable(node: MapNodeData) -> bool:
	if current_node == null:
		return node.level == 1 # only floor-1 nodes selectable at game start
	return current_node.next_nodes.has(node)
