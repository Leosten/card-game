class_name EncounterChoice
extends Control

@onready var choice_label: Label = %ChoiceLabel
var encounter_type : StageManager.level_type

signal clicked
signal hovered
signal hovered_out

func init(encounter_t : StageManager.level_type):
	encounter_type = encounter_t
	choice_label.text = StageManager.get_encounter_name_by_type(encounter_t)

func _on_clicked() -> void:
	print("clicked ", encounter_type)
	clicked.emit(encounter_type)
