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

func _on_hovered() -> void:
	print("Hovereeed")
	pass # Replace with function body.


func _on_button_pressed() -> void:
	clicked.emit(encounter_type)
	print("button pressed")
