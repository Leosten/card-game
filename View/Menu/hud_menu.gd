extends CanvasLayer

@onready var center_root = $%CenterWindowRoot
var deck_list_window_scene = load("res://View/Menu/deck_list_window.tscn")
var reward_window_scene = load("res://View/Menu/victory_window.tscn")	
var next_level_window_scene = load("res://View/Menu/next_level_window/next_level_window.tscn")	
var deck_list_window : Node
var reward_window : Node
var next_level_window : Node

func _ready() -> void:
	# Listen to global requests
	Events.request_window_open.connect(_on_window_open_requested)
	Events.request_window_close.connect(_on_window_close_requested)
	Events.next_battle.connect(on_level_change)
	
func _on_window_open_requested(window_name: String, extra_data: Dictionary = {}) -> void:
	match window_name:
		"reward":
			reward_window = reward_window_scene.instantiate()
			center_root.add_child(reward_window)
		"deck":
			deck_list_window = deck_list_window_scene.instantiate()
			center_root.add_child(deck_list_window)
		"next_level":
			next_level_window = next_level_window_scene.instantiate()
			center_root.add_child(next_level_window)
			
func _on_window_close_requested(window_name: String) -> void:
	match window_name:
		"reward": reward_window.queue_free()
		"deck": deck_list_window.queue_free()
		"next_level" : next_level_window.queue_free()
		
func _on_deck_list_button_pressed() -> void:
	Events.request_window_open.emit("deck")
	
func on_level_change():
	%CurrentLevelLabel.text = "Level " + str(GameManager.current_stage) + " - " + str(GameManager.current_level)
