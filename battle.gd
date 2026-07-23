extends Node2D

var player_stats: PlayerStats
var current_stage: int
var current_level: int
var current_turn: int = 0
var current_monsters : Array[MonsterData]
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	current_turn = 1
	player_stats = GameManager.player_stats
	current_level = GameManager.current_level
	current_stage = GameManager.current_stage
	print('current_stage is %s' % str(current_stage))
	print('current_level is %s' % str(current_level))
	pass # Replace with function body.
	spawn_player_character()
	spawn_monster_characters()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_player_character():
	var player_character = GameManager.get_character_scene()
	var viewport_size := get_viewport_rect().size

	var char_position := Vector2(
			viewport_size.x - 1400,
			viewport_size.y - 650
		)

	player_character.position = char_position
	add_child(player_character)

func spawn_monster_characters():
	pass
