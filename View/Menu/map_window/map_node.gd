class_name MapNode
extends Control

@onready var choice_label: Label = %ChoiceLabel
@onready var path_line: Line2D = %PathLine
@onready var background : TextureRect = %Background
@export var line_color: Color = Color.RED
@export var line_width: float = 2.0

var encounter_type : StageManager.level_type
var node_data : MapNodeData

signal clicked(encounter_type)
signal hovered
signal hovered_out

func on_ready() -> void:
	choice_label.text = StageManager.get_encounter_name_by_type(encounter_type)

func init(node_d : MapNodeData):
	node_data = node_d
	encounter_type = node_d.encounter_type
	background.texture = node_d.background

func _on_hovered() -> void:
	pass # Replace with function body.

func _on_button_pressed() -> void:
	clicked.emit(encounter_type)

func _on_clicked() -> void:
	clicked.emit(encounter_type)
