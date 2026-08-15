extends Control

var encounter_choice_scene = preload("res://View/Menu/next_level_window/encounter_choice.tscn")
var possible_encounters_type := []
var selected_choice = null

func _ready() -> void:
	possible_encounters_type = GameManager.stage_manager.get_stage_encounter_types(GameManager.stage_manager.current_level + 1)
	display_encounter_choices()

func display_encounter_choices():
	for encounter in possible_encounters_type:
		print("encounter in for: " , encounter)
		var choice = encounter_choice_scene.instantiate()
		choice.hovered.connect(_on_choice_hovered)
		choice.hovered_out.connect(_on_choice_hovered_out)
		choice.clicked.connect(_on_choice_clicked)
		%ChoicesContainer.add_child(choice)
		var background = GameManager.card_manager.get_large_card_background(encounter)
		choice.init(encounter, background)

func _on_choice_hovered():
	pass
	
func _on_choice_clicked(choice : StageManager.level_type):
	print("selected choice : ", choice)
	selected_choice = choice
	
func _on_choice_hovered_out():
	pass

func _on_next_button_pressed() -> void:
	if (selected_choice == null):
		return
	GameManager.stage_manager.encounter_progress()
	GameManager.stage_manager.current_encounter_type = selected_choice
	Events.next_encounter.emit()
	#await ScreenTransition.wipe_out(0.5)
	Events.request_window_close.emit("next_level")

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
