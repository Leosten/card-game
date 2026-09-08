class_name ForgeManager
extends Node

var forge_scene

var upgrade_price


const TIER_PRICES: Dictionary = {
	CardUtils.tier.COMMON: Vector2i(25, 45),
	CardUtils.tier.PURPLE: Vector2i(50, 85),
	CardUtils.tier.GOLD: Vector2i(100, 160),
}

func get_forge_scene():
	print("Character number 0 scene loading")
	var forge : PackedScene = preload("res://View/Battle/forge_character/forge_character.tscn")
	
	if forge == null:
		printerr("Cannot load forge scene")
		return null
		
	return forge.instantiate()

func set_forge_battle_position(forge):
	var char_position := Vector2(
		GameManager.viewport_size.x - 700,
		GameManager.viewport_size.y - 800
	)
	return forge
