extends Node

var stats : Targetable
var local_status: Array[StatusEffect]

func init_stats_window(p_stats: Targetable):
	stats = p_stats
	stats.stats_changed.connect(update_stats)
	stats.status_manager.statuses_updated.connect(update_status_icons)
	update_stats()
	
func update_stats():
	#print("SHIELD VALUE FINAL: %s" % stats.shield)
	if stats.shield > 0:
		$VBoxContainer/HealthBar/ShieldBar.show()
		$VBoxContainer/HealthBar/ShieldBar.value = stats.shield
		$VBoxContainer/HealthBar/ShieldBar.custom_minimum_size.x = stats.shield
		$VBoxContainer/HealthBar/ShieldValue.show()
		$VBoxContainer/HealthBar/ShieldValue.text = str(stats.shield)
	else:
		$VBoxContainer/HealthBar/ShieldBar.hide()
		$VBoxContainer/HealthBar/ShieldValue.hide()
	$VBoxContainer/HealthBar.value = stats.health
	$VBoxContainer/HealthBar.max_value = stats.max_health
	$VBoxContainer/HealthBar/CenterContainer/HBoxContainer/Health.text = str(stats.health)
	$VBoxContainer/HealthBar/CenterContainer/HBoxContainer/MaxHealth.text = str(stats.max_health)

func update_status_icons():
	for icon in $VBoxContainer/BuffsGrid.get_children():
		icon.queue_free()
	var statuses : Dictionary = stats.status_manager.get_statuses()
	if statuses.is_empty():
		return
	
	for status : Status in statuses.values():
		print("status: " ,status)
		var icon = GameManager.ui_manager.get_icon_scene(status)
		icon.set_stacks(status.stacks)
		$VBoxContainer/BuffsGrid.add_child(icon)
