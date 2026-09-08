extends CanvasLayer

@onready var center_root = $%CenterWindowRoot
@onready var current_level_display = %CurrentLevelLabel

var deck_list_window_scene = load("res://View/Menu/deck_list_window/deck_list_window.tscn")
var map_window_scene = load("res://View/Menu/map_window/map_window.tscn")
var shop_window_scene = load("res://View/Menu/shop_window/shop_window.tscn")
var forge_window_scene = load("res://View/Menu/forge_window/forge_window.tscn")
var reward_window_scene = load("res://View/Menu/victory_window/victory_window.tscn")	
var next_level_window_scene = load("res://View/Menu/next_level_window/next_level_window.tscn")	
var deck_list_window : Node
var map_window : Node
var shop_window : Node
var forge_window : Node
var reward_window : Node
var next_level_window : Node

func _ready() -> void:
	Events.request_window_open.connect(_on_window_open_requested)
	Events.request_window_close.connect(_on_window_close_requested)
	Events.next_encounter.connect(on_level_change)

func _on_window_open_requested(window_name: String, extra_data: Dictionary = {}) -> void:
	match window_name:
		"reward":
			reward_window = reward_window_scene.instantiate()
			center_root.add_child(reward_window)
		"deck":
			deck_list_window = deck_list_window_scene.instantiate()
			deck_list_window.with_data(extra_data)
			center_root.add_child(deck_list_window)
		"map":
			map_window = map_window_scene.instantiate()
			map_window.with_data(extra_data)
			center_root.add_child(map_window)
		"shop":
			if (is_instance_valid(shop_window)):
				shop_window.visible = true
				return
			shop_window = shop_window_scene.instantiate()
			center_root.add_child(shop_window)
		"forge":
			if (is_instance_valid(forge_window)):
				forge_window.visible = true
				return
			forge_window = forge_window_scene.instantiate()
			center_root.add_child(forge_window)
		"next_level":
			await ScreenTransition.wipe_out(0.6)
			next_level_window = next_level_window_scene.instantiate()
			center_root.add_child(next_level_window)
			await ScreenTransition.wipe_in(0.6)

func _on_window_close_requested(window_name: String) -> void:
	match window_name:
		"reward": reward_window.queue_free()
		"deck": deck_list_window.queue_free()
		"map":
			if map_window.selection == true:
				await ScreenTransition.wipe_out(0.6)
			map_window.queue_free()
			if map_window.selection == true:
				await ScreenTransition.wipe_in(0.6)
		"shop":
			if shop_window != null: 
				shop_window.queue_free()
		"forge":
			if forge_window != null: 
				forge_window.queue_free()
		"next_level" : 
			await ScreenTransition.wipe_out(0.6)
			next_level_window.queue_free()
			await ScreenTransition.wipe_in(0.6)

func _on_deck_list_button_pressed() -> void:
	Events.request_window_open.emit("deck")

func _on_map_button_pressed() -> void:
	Events.request_window_open.emit("map")

func on_level_change():
	current_level_display.text = "Level " + str(GameManager.stage_manager.current_stage) + " - " + str(GameManager.stage_manager.current_level)
