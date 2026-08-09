extends Node2D

func update_mana(current_mana):
	var color
	if (current_mana > 0):
		color = Color(0.149, 0.959, 0.792, 1.0)
	else:
		color = Color(0.0, 0.0, 0.0, 1.0)
	$ManaLabel.label_settings.font_color = color
	$ManaLabel.text = str(current_mana)
