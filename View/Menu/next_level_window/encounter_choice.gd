class_name EncounterChoice
extends Control

@onready var choice_label: Label = %ChoiceLabel
var encounter_type : StageManager.level_type

signal clicked(encounter_type)
signal hovered
signal hovered_out

func init(encounter_t : StageManager.level_type, background: Texture2D):
	encounter_type = encounter_t
	choice_label.text = StageManager.get_encounter_name_by_type(encounter_t)
	%Background.texture = background

func _on_hovered() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	clicked.emit(encounter_type)


func _on_clicked() -> void:
	clicked.emit(encounter_type)
