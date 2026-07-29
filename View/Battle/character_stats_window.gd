extends Node

var stats : Targetable

func update():
	$VBoxContainer/HealthBar.value = stats.health
	$VBoxContainer/HealthBar.max_value = stats.max_health
	$VBoxContainer/HealthBar/ShieldBar.value = stats.shield
	$VBoxContainer/HealthBar/ShieldBar.max_value = stats.max_health
	
	$VBoxContainer/HealthBar/CenterContainer/HBoxContainer/Health.text = str(stats.health)
	$VBoxContainer/HealthBar/CenterContainer/HBoxContainer/MaxHealth.text = str(stats.max_health)
