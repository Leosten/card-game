extends Node

var stats : Targetable
var local_buffs: Array[Buff]
var local_status: Array[StatusEffect]

func update():
	print("SHIELD VALUE FINAL: %s" % stats.shield)
	if stats.shield > 0:
		$VBoxContainer/HealthBar/ShieldBar.show()
		$VBoxContainer/HealthBar/ShieldBar.value = stats.shield
		$VBoxContainer/HealthBar/ShieldBar.max_value = stats.shield
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
	if stats.status_effects.is_empty() == false:
		print("check statuses")
		for status : StatusEffect in stats.status_effects:
			if status not in local_status:
				print(status.type)
				var icon = GameManager.ui_manager.get_icon(status.type).instantiate()
				$BuffsGrid.add_child(icon)
				local_status.append(status)
			
