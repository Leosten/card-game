extends Node

var stats : Targetable
var local_buffs: Array[Buff]
var local_status: Array[StatusEffect]

func update():
	print("SHIELD VALUE FINAL: %s" % stats.shield)
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
	
	#if stats.buffs.is_empty() == false:
		#print("check buffs")
		#local_buffs = stats.buffs
		#for buff : Buff in stats.buffs:
			#if buff not in local_buffs:
				#var icon = GameManager.ui_manager.get_icon(buff.type).new()
				#$BuffsGrid.add_child(icon)0
	print("in update")
	print(stats.status_effects)
	
	for icon in $VBoxContainer/BuffsGrid.get_children():
		print("clear statuses")
		icon.queue_free()
	if stats.buffs.is_empty() == false:
		print("check buffs")
		for status : Buff in stats.buffs:
			var icon = GameManager.ui_manager.get_icon(status.type).instantiate()
			icon.update(status)
			$VBoxContainer/BuffsGrid.add_child(icon)
	if stats.status_effects.is_empty() == false:
		print("check status_effects")
		for status : StatusEffect in stats.status_effects:
			var icon = GameManager.ui_manager.get_icon(status.type).instantiate()
			icon.update(status)
			$VBoxContainer/BuffsGrid.add_child(icon)
			
