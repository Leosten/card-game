class_name PlayerStats

extends Targetable

signal current_mana_changed

@export var current_mana : int = 5
@export var max_mana : int = 5
@export var initial_draw_value = 5
@export var draw_value : int = 5
@export var level_progression: int = 0
@export var stage_progression: int = 0
@export var char_id = 0
@export var nb_card_reward = 3
@export var gold_reward_modifier = 0
@export var gold = 1000
@export var items = []


var companion_stats : CompanionStats

func cleanup_fight():
	status_manager.cleanup_fight()
	current_mana = max_mana
	draw_value = initial_draw_value
	companion_stats.cleanup_fight()
