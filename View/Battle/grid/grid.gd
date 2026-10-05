extends Node2D

@onready var main_grid = $MainGrid
@onready var target_highlight_grid = $TargetHighlightGrid
@onready var enemy_action_highlight_grid = $EnemyHighlightGrid

var grid_manager : GridManager

func _ready() -> void:
	grid_manager = GameManager.grid_manager
	grid_manager.main_grid = main_grid
	grid_manager.target_highlight_grid = target_highlight_grid
	grid_manager.enemy_action_highlight_grid = enemy_action_highlight_grid
	Events.turn_start.connect(_on_turn_start)

func _on_turn_start():
	grid_manager.draw_battlefield_squares()

func preview_enemy_actions():
	var enemies = GameManager.battle_state.level_monsters
	for enemy : MonsterData in enemies:
		enemy.get_next_step()
