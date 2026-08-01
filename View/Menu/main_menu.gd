extends Node2D

@export var battle_scene = "res://battle.tscn"

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	SceneLoader.load_scene(battle_scene)
