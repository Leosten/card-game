class_name EncounterChoice
extends Control

@onready var choice_label: Label = %ChoiceLabel

signal clicked
signal hovered
signal hovered_out

func init(encounter_type : StageManager.level_type):
	choice_label.text = StageManager.get_encounter_name_by_type(encounter_type)
