extends Control

var encounter_choice = preload("res://View/Menu/next_level_window/encounter_choice.tscn")
var possible_encounters_type
var selected_choice = null

func _ready() -> void:
	possible_encounters_type = GameManager.stage_manager.get_stage_encounter_types(GameManager.current_level + 1)
	display_encounter_choices()
	
func display_encounter_choices():
	for encounter in possible_encounters_type:
		var choice = encounter_choice.instantiate()
		choice.init(encounter)
		choice.hovered.connect(_on_choice_hovered)
		choice.hovered_out.connect(_on_choice_hovered_out)
		choice.clicked.connect(_on_choice_clicked)
		%ChoicesContainer.add_child(encounter_choice)

func _on_choice_hovered():
	pass
func _on_choice_clicked():
	pass
func _on_choice_hovered_out():
	pass

func _on_next_button_pressed() -> void:
	pass # Replace with function body.


static func zoom_in(choice : EncounterChoice):
	choice.pivot_offset = choice.size / 2.0
	
	if choice.active_tween:
		choice.active_tween.kill()
	choice.active_tween = choice.create_tween().set_trans(Tween.TRANS_QUAD)
	choice.active_tween.tween_property(
		choice, "scale",
		Vector2(1.2, 1.2),
		0.2
	).set_ease(Tween.EASE_OUT)
	
static func zoom_out(choice : EncounterChoice):
	if choice.active_tween:
		choice.active_tween.kill()
	choice.active_tween = choice.create_tween().set_trans(Tween.TRANS_LINEAR)
	choice.active_tween.tween_property(
		choice, "scale",
		Vector2(1.0, 1.0),
		0.2
	).set_ease(Tween.EASE_IN)
