extends Node2D

signal player_turn_start
signal player_turn_end
signal enemy_turn_start
signal enemy_turn_end
signal tile_clicked

var battle_state : BattleState
var current_stage: int
var current_level: int
var current_turn: int = 0
var enemy_turn : bool = false
var current_encounter : StageManager.level_type = StageManager.level_type.COMMON
var stage_manager : StageManager
var character_manager : CharacterManager
var monster_manager : MonsterManager
var action_manager : ActionManager
var battle_animation_manager : BattleAnimationManager

var enemy_positions : Array[Area2D] = []

@onready var card_hand_hud = %CardHandHud
@onready var end_turn_button = %EndTurnButton
@onready var mana_window = $%ManaWindow
@onready var grid_display = %Grid
@onready var targeting_line: TargetingLine2D = $TargetingLine2D
var card_clicked: Card = null

func _process(delta: float) -> void:
	draw_targeting_line()

func _ready() -> void:
	Events.next_encounter.connect(new_encounter)
	Events.battle_won.connect(_victory)
	
	player_turn_start.connect(_on_player_turn_start)
	player_turn_end.connect(_on_player_turn_end)
	enemy_turn_end.connect(_on_enemy_turn_end)
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	end_turn_button.button_pressed.connect(_on_end_turn_button_pressed)
	stage_manager = GameManager.stage_manager
	monster_manager = GameManager.monster_manager
	character_manager = GameManager.character_manager
	battle_animation_manager = BattleAnimationManager.new()
	add_child(battle_animation_manager)
	action_manager = ActionManager.new()
	battle_state = GameManager.battle_state

	spawn_player_character()
	spawn_companion_character()
	new_stage()
	Events.request_window_open.emit('map', {"selection": true})

func new_encounter():
	print("new_encounter")
	current_encounter = GameManager.map_manager.current_node.encounter_type
	match current_encounter:
		StageManager.level_type.COMMON:
			start_battle()
		StageManager.level_type.MINIBOSS:
			start_battle()
		StageManager.level_type.BOSS:
			start_boss_battle()
		StageManager.level_type.TREASURE:
			pass
		StageManager.level_type.RANDOM:
			GameManager.stage_manager.get_random_encounter()
			new_encounter()
		StageManager.level_type.SHOP:
			start_shop()
		StageManager.level_type.FORGE:
			start_forge()
		_:
			pass

func start_battle():
	Events.battle_start.emit()
	grid_display.visible = true
	print("start battle")
	battle_state.current_turn = 1
	battle_state.replenish_player_mana()
	spawn_level_monsters()
	player_turn_start.emit()

func start_boss_battle():
	pass

func start_shop():
	Events.shop_start.emit()
	grid_display.visible = false
	var shop_character = GameManager.shop_manager.get_shop_scene()
	add_child(shop_character)

func start_forge():
	Events.shop_start.emit()
	grid_display.visible = false
	var forge = GameManager.forge_manager.get_forge_scene()
	add_child(forge)

func new_stage():
	GameManager.new_stage()

func spawn_player_character():
	var player_character = character_manager.get_character_scene()
	add_child(player_character)

func spawn_companion_character():
	var companion_character = character_manager.get_companion_scene()
	add_child(companion_character)

func spawn_level_monsters():
	var monster_scenes = monster_manager.get_level_monster_scenes()
	for monster_scene : Monster in monster_scenes :
		add_child(monster_scene)
		await get_tree().create_timer(0.3).timeout
	print("Monsters spawned")

func _on_card_clicked(card: Card) -> void:
	if enemy_turn == true:
		return
	if card_clicked != null and card == card_clicked:
		action_manager.use_card_on_ally(card_clicked.card_data)
		print("click on self card")
		stop_targeting()
		return
	if card.card_data.cost > CharacterUtils.get_current_mana(battle_state):
		print("not enough mana")
		stop_targeting()
		return
	card_clicked = card

func _on_monster_hovered():
	pass

func launch_enemy_turn():
	for enemy in monster_manager.level_monsters:
		action_manager.enemy_cycle(enemy)
		await get_tree().create_timer(0.5).timeout
	enemy_turn_end.emit()

func _on_enemy_turn_end():
	Events.turn_end.emit()
	current_turn += 1
	player_turn_start.emit()

func _on_end_turn_button_pressed() -> void:
	player_turn_end.emit()

func _on_player_turn_end():
	await card_hand_hud.discard_all()
	await battle_animation_manager.short_pause()
	await launch_enemy_turn()

func _on_player_turn_start():
	Events.turn_start.emit()
	battle_state.replenish_player_mana()
	enemy_turn = false
	
func _victory():
	await _cleanup_fight()
	Events.request_window_open.emit("reward", {"gold" : 0})

func _cleanup_fight():
	battle_state.cleanup_fight()
	# status effects
	# exhausted cards
	# clear hands/draw
	# block mouse control filter
	pass

func draw_targeting_line():
	if card_clicked == null:
		return
	TargetingUtils.draw_mouse_card_targeting_line(targeting_line, card_clicked, get_local_mouse_position())

func stop_targeting() -> void:
	card_clicked = null
	targeting_line.hide_line()
	GameManager.grid_manager.stop_aoe_preview()

func _input(event: InputEvent) -> void:
	if card_clicked == null:
		return
	if not (event is InputEventMouseButton and event.pressed):
		return

	if event.button_index == MOUSE_BUTTON_RIGHT:
		stop_targeting()
		get_viewport().set_input_as_handled()
		return

	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	var clicked_cell: Vector2i = TargetingUtils.get_clicked_cell(GameManager.grid_manager.target_highlight_grid, get_global_mouse_position())
	
	var bounds: Rect2i = GameManager.grid_manager.get_card_target_bounds(card_clicked.card_data)
	if not bounds.has_point(clicked_cell):
		return # click missed the grid (e.g. hit a card/UI) -> propagate normally

	tile_clicked.emit(clicked_cell)
	if GameManager.grid_manager.is_valid_target_cell():
		action_manager.use_card_on_grid(clicked_cell, card_clicked.card_data)
		stop_targeting()
	get_viewport().set_input_as_handled()
