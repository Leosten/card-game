extends Node2D

@onready var mana_label : Label = %ManaLabel

func _ready():
	GameManager.battle_state.player_stats.current_mana_changed.connect(on_mana_changed)

func on_mana_changed():
	var current_mana = GameManager.battle_state.player_stats.current_mana
	var color
	if (current_mana > 0):
		color = Color(0.435, 0.616, 0.506, 1.0)
	else:
		color = Color(0.0, 0.0, 0.0, 1.0)
	mana_label.add_theme_color_override("font_color", color)
	mana_label.text = str(current_mana)
