class_name DamageNumberManager
extends Control

@export var damage_number_scene: PackedScene
const DAMAGE_NUMBER_SCENE = preload("res://View/UI/damage_number.tscn")
func _ready() -> void:
	# Listen to global damage events
	Events.damage_taken.connect(_on_damage_dealt)

func _on_damage_dealt(amount: int, world_pos: Vector2) -> void:
	#if not damage_number_scene:
		#return
	
	var number_label = DAMAGE_NUMBER_SCENE.instantiate()
	add_child(number_label)
	
	# Add a small random offset so numbers don't overlap directly on top of each other
	var random_offset = Vector2(randf_range(-15, 15), randf_range(-10, 10))
	number_label.global_position = world_pos + random_offset
	
	# Initialize the number text and pop animation
	number_label.setup(amount)
