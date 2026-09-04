class_name MapNode
extends Control

@onready var choice_label: Label = %ChoiceLabel
@onready var background : TextureRect = %Background
@onready var _animation_player : AnimationPlayer = $AnimationPlayer
@export var line_color: Color = Color.RED
@export var line_width: float = 2.0

var encounter_type : StageManager.level_type
var node_data : MapNodeData

signal clicked(node)
signal hovered
signal hovered_out

func ready() -> void:
	choice_label.text = StageManager.get_encounter_name_by_type(encounter_type)
	play_animation()
	
func init(node_d : MapNodeData):
	node_data = node_d
	encounter_type = node_d.encounter_type

func set_background():
	background.texture = node_data.background
	play_animation()
func _on_hovered() -> void:
	pass # Replace with function body.

func _on_button_pressed() -> void:
	print("clicked button")
	clicked.emit(self)

func _on_clicked() -> void:
	clicked.emit(self)

func select_toggle():
	if (_animation_player.current_animation == "selectable"):
		_animation_player.play("selected")
		return
	_animation_player.play("selectable")

func play_animation():
	if GameManager.map_manager.is_node_selectable(node_data):
		_animation_player.play("selectable")
	if (node_data.level) < GameManager.stage_manager.current_level:
		_animation_player.play("disabled")
