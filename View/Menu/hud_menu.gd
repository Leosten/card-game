extends CanvasLayer

@onready var center_root = $%CenterWindowRoot

func _on_deck_list_button_pressed() -> void:
	print("deck list button pressed")
	var deck_list_window = load("res://View/Menu/deck_list_window.tscn")
	center_root.add_child(deck_list_window.instantiate())
