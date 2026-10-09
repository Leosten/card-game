extends Node2D

@onready var main_grid = $MainGrid
@onready var target_highlight_grid = $TargetHighlightGrid
@onready var enemy_action_highlight_grid = $EnemyActionHighlightGrid

var grid_manager : GridManager

func _ready() -> void:
	grid_manager = GameManager.grid_manager
	grid_manager.main_grid = main_grid
	grid_manager.target_highlight_grid = target_highlight_grid
	grid_manager.enemy_action_highlight_grid = enemy_action_highlight_grid
	Events.turn_start.connect(_on_turn_start)
	Events.battle_start.connect(_on_battle_start)

func _on_battle_start():
	grid_manager.draw_battlefield_squares()

func _on_turn_start():
	grid_manager.clear_enemy_action_highlight()
	preview_enemy_actions()

func preview_enemy_actions():
	var enemies = GameManager.monster_manager.level_monsters
	for enemy : MonsterData in enemies:
		var monster_action = enemy.get_action()
		grid_manager.update_monster_aoe_preview(enemy.grid_position, monster_action)
