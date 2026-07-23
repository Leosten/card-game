extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_player_character()

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
