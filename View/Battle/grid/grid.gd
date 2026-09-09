extends Node2D

@onready var player_grid = $PlayerGrid
@onready var enemy_grid = $EnemyGrid
@onready var player_highlight_grid = $PlayerHighlightGrid
@onready var enemy_highlight_grid = $EnemyHighlightGrid

func _ready() -> void:
	GameManager.grid_manager.enemy_grid = enemy_grid
	GameManager.grid_manager.player_grid = player_grid
	GameManager.grid_manager.player_highlight_grid = player_highlight_grid
	GameManager.grid_manager.enemy_highlight_grid = enemy_highlight_grid
