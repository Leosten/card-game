extends Node

var stats : Targetable
var local_status: Array[StatusEffect]

@onready var shield_bar = %ShieldBar
@onready var shield_value = %ShieldValue
@onready var health = %Health
@onready var health_bar = %HealthBar
@onready var max_health = %MaxHealth
@onready var buffs_grid = %BuffsGrid

func init_stats_window(p_stats: Targetable):
	stats = p_stats
	stats.stats_changed.connect(update_stats)
	stats.status_manager.statuses_updated.connect(update_status_icons)
	update_stats()
	
func update_stats():
	if stats.shield > 0:
		shield_bar.show()
		shield_bar.value = stats.shield
		shield_bar.custom_minimum_size.x = stats.shield
		shield_value.show()
		shield_value.text = str(stats.shield)
	else:
		shield_bar.hide()
		shield_value.hide()
	health_bar.value = stats.health
	health_bar.max_value = stats.max_health
	health.text = str(stats.health)
	max_health.text = str(stats.max_health)

func update_status_icons():
	for icon in buffs_grid.get_children():
		icon.queue_free()
		
	var statuses : Dictionary = stats.status_manager.get_statuses()
	if statuses.is_empty():
		return
	
	for status : StatusTemplate in statuses.values():
		print("status: " ,status)
		var icon = GameManager.ui_manager.get_icon_scene(status)
		icon.set_stacks(status.stacks)
		buffs_grid.add_child(icon)
