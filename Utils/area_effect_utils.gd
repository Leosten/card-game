class_name  AreaEffectUtils
extends Node

static func pattern_origin_middle():
	return Vector2i(0,0)

static func pattern_origin_left_middle():
	return Vector2i(0,1)

static func pattern_origin_middle_three_by_three():
	return Vector2i(0,2)

# 1. Single Target / Melee Strike
# Hits only the targeted square.
static func pattern_single() -> Array[Vector2i]:
	return [Vector2i(0, 1)]

# 2. Horizontal Cleave (3-Tile Line)
# Great for sweeping front-line enemies horizontally.
static func pattern_cleave_h() -> Array[Vector2i]:
	return [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)]

# 3. Piercing Thrust (3-Tile Vertical Line)
# Hits target and penetrates 2 tiles behind it (or forward along Y).
static func pattern_pierce_three_v() -> Array[Vector2i]:
	return [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]

static func pattern_pierce_four_v() -> Array[Vector2i]:
	return [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1),Vector2i(5, 1)]

static func pattern_pierce_v(cell_nb) -> Array[Vector2i]:
	var pattern : Array[Vector2i] = []
	for nb in cell_nb:
		var vector : Vector2i
		vector.x = nb
		vector.y = 1
		pattern.append(vector)
	return pattern

# 4. Cross Pattern (Classic Plus Shape)
# Target + adjacent cardinal cells (5 tiles total).
static func pattern_cross() -> Array[Vector2i]:
	return [
		Vector2i(0, 0),
		Vector2i(0, -1), Vector2i(0, 1), # Up, Down
		Vector2i(-1, 0), Vector2i(1, 0)   # Left, Right
	]

# 5. Diagonal X-Pattern
# Hits diagonals surrounding target (5 tiles total).
static func pattern_diagonal_x() -> Array[Vector2i]:
	return [
		Vector2i(0, 0),
		Vector2i(-1, -1), Vector2i(1, -1), # Top-Left, Top-Right
		Vector2i(-1, 1),  Vector2i(1, 1)   # Bottom-Left, Bottom-Right
	]

# 6. 2x2 Area Blast
# Hits origin and 3 adjacent cells forming a square block.
static func pattern_square_2x2() -> Array[Vector2i]:
	return [
		Vector2i(0, 0), Vector2i(1, 0),
		Vector2i(0, 1), Vector2i(1, 1)
	]

# 7. 3x3 Large AOE (Meteor / Bomb)
# Hits target cell and all 8 surrounding neighbor tiles.
static func pattern_3x3_aoe() -> Array[Vector2i]:
	return [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0), Vector2i(0,  0), Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

# 8. Hollow Ring / Donut (Sniper or Artillery)
# Hits only surrounding cells, leaving center cell safe (8 tiles total).
func pattern_donut() -> Array[Vector2i]:
	return [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

# 9. Knight's Leap (Chess L-Shape)
# Hits all 8 L-shaped jump positions around target cell.
func pattern_knight_jumps() -> Array[Vector2i]:
	return [
		Vector2i(-1, -2), Vector2i(1, -2),
		Vector2i(-2, -1), Vector2i(2, -1),
		Vector2i(-2,  1), Vector2i(2,  1),
		Vector2i(-1,  2), Vector2i(1,  2)
	]
