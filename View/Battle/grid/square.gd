class_name Square
extends PanelContainer

var is_player := true
var is_enemy := false
var occupier : Targetable = null

var player_color = Color(0.475, 0.894, 1.0, 1.0)
var enemy_color = Color(0.741, 0.318, 0.427, 1.0)

func _ready() -> void:
	pass


func _on_mouse_entered() -> void:
	print("entered ", self.position)
	pass # Replace with function body.
