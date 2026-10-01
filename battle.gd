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
var stage_monsters : Array[MonsterData]
var monsters_displayed : Array[Monster]
var player_character : Node2D
var companion_character : AnimatableBody2D
var current_encounter : StageManager.level_type = StageManager.level_type.COMMON
var stage_manager : StageManager
var action_manager : ActionManager
var battle_animation_manager : BattleAnimationManager

var enemy_positions : Array[Area2D] = []

@onready var card_hand_hud = %CardHandHud
@onready var end_turn_button = %EndTurnButton
@onready var mana_window = $%ManaWindow
@onready var grid_display = %Grid
@onready var targeting_line: TargetingLine2D = $TargetingLine2D
var card_clicked: CardData = null

func _process(delta: float) -> void:
	draw_targeting_line()

func _ready() -> void:
	Events.next_encounter.connect(new_encounter)
	player_turn_start.connect(on_player_turn_start)
	player_turn_end.connect(on_player_turn_end)
	enemy_turn_end.connect(on_enemy_turn_end)
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	end_turn_button.button_pressed.connect(_on_end_turn_button_pressed)
	stage_manager = GameManager.stage_manager
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
	grid_display.visible = true
	print("start battle")
	Events.battle_start.emit()
	current_turn = 1
	battle_state.replenish_player_mana()
	battle_state.level_monsters = stage_manager.get_level_monsters()
	GameManager.character_manager.set_main_char_battle_position(player_character, grid_display.main_grid)
	GameManager.character_manager.set_companion_char_battle_position(companion_character, grid_display.main_grid)
	spawn_level_monsters()
	player_turn_start.emit()

func start_boss_battle():
	pass

func start_shop():
	grid_display.visible = false
	var shop_character = GameManager.shop_manager.get_shop_scene()
	GameManager.shop_manager.set_shop_battle_position(shop_character)
	GameManager.character_manager.set_main_char_shop_position(player_character)
	GameManager.character_manager.set_companion_char_shop_position(companion_character)
	add_child(shop_character)

func start_forge():
	grid_display.visible = false
	var forge = GameManager.forge_manager.get_forge_scene()
	GameManager.forge_manager.set_forge_battle_position(forge)
	add_child(forge)

func new_stage():
	GameManager.map_manager.generate_map()
	stage_monsters = stage_manager.get_stage_monsters()

func spawn_player_character():
	player_character = GameManager.get_character_scene()
	player_character.init(battle_state)
	add_child(player_character)

func spawn_companion_character():
	companion_character = GameManager.get_companion_scene()
	companion_character.init(battle_state.player_stats.companion_stats)
	add_child(companion_character)

func spawn_level_monsters():
	#enemy_positions = stage_manager.init_monster_positions()
	var monster_scenes = stage_manager.get_monster_scenes_for_level(battle_state.level_monsters)
	for monster_scene : Monster in monster_scenes :
		monster_scene.hovered.connect(on_monster_hovered)
		monster_scene.dead.connect(on_monster_dead)
		add_child(monster_scene)
		monsters_displayed.append(monster_scene)
		monster_scene.spawn()
		await get_tree().create_timer(0.3).timeout
	print("Monsters spawned")

func _on_card_clicked(card_data: CardData) -> void:
	if enemy_turn == true:
		return
	if card_clicked != null and card_data == card_clicked:
		action_manager.use_card_on_ally(card_clicked)
		print("click on self card")
		stop_targeting()
		return
	if card_data.cost > CharacterUtils.get_current_mana(battle_state):
		print("not enough mana")
		stop_targeting()
		return
	card_clicked = card_data

func on_monster_hovered():
	pass

func on_monster_dead(monster : MonsterData):
	print("monster %s dead!" % monster.battle_position)
	Events.monster_dead.emit(monster)
	battle_state.level_monsters.erase(monster)
	check_monsters_dead()
	monsters_displayed = MonsterUtils.remove_monster_dead_display(monsters_displayed, monster)

func check_monsters_dead():
	if battle_state.level_monsters.is_empty() == true:
		print("WIN all enemies dead")
		card_hand_hud.discard_all()
		victory()

func launch_enemy_turn():
	for enemy in battle_state.level_monsters:
		action_manager.enemy_cycle(enemy)
		await get_tree().create_timer(0.5).timeout
	enemy_turn_end.emit()

func on_enemy_turn_end():
	Events.turn_end.emit()
	current_turn += 1
	player_turn_start.emit()

func _on_end_turn_button_pressed() -> void:
	player_turn_end.emit()

func on_player_turn_end():
	await card_hand_hud.discard_all()
	await battle_animation_manager.short_pause()
	await launch_enemy_turn()

func on_player_turn_start():
	Events.turn_start.emit()
	battle_state.replenish_player_mana()
	enemy_turn = false

func victory():
	Events.battle_won.emit()
	await _cleanup_fight()
	Events.request_window_open.emit("reward", {"gold" : 0})

func _cleanup_fight():
	battle_state.cleanup_fight()
	await card_hand_hud.cleanup_fight()
	# status effects
	# exhausted cards
	# clear hands/draw
	# block mouse control filter
	pass

func draw_targeting_line():
	if card_clicked == null:
		return
	var selected_card = card_hand_hud.displayed_hand.filter(func(card: Card) -> bool: return card.hand_position == card_clicked.hand_position)
	if selected_card.is_empty() == true:
		return
	# 1. Start point = Center of card UI element
	var start_pos: Vector2 = selected_card[0].global_position + (selected_card[0].size * 0.5)

	var overlay_tilemap : TileMapLayer = GameManager.grid_manager.target_highlight_grid
	var target_bounds : Rect2i = GameManager.grid_manager.get_card_target_bounds(card_clicked)
	# 2. Get target cell from current mouse cursor position
	var mouse_pos: Vector2 = get_global_mouse_position()
	var local_mouse: Vector2 = overlay_tilemap.to_local(mouse_pos)
	var target_cell: Vector2i = overlay_tilemap.local_to_map(local_mouse)

	var end_pos: Vector2

	if target_bounds.has_point(target_cell):
	# Valid arena tile -> Snap to grid center
		var cell_local_center: Vector2 = overlay_tilemap.map_to_local(target_cell)
		end_pos = overlay_tilemap.to_global(cell_local_center)
	else:
	# Outside arena -> Fallback to raw mouse position
		end_pos = mouse_pos
	targeting_line.update_targeting_curve(start_pos, end_pos)
	GameManager.grid_manager.update_card_aoe_preview(target_cell, card_clicked, overlay_tilemap, target_bounds)

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

	var target_grid = GameManager.grid_manager.target_highlight_grid
	var mouse_pos: Vector2 = get_global_mouse_position()
	var local_pos: Vector2 = target_grid.to_local(mouse_pos)
	var clicked_cell: Vector2i = target_grid.local_to_map(local_pos)

	var bounds: Rect2i = GameManager.grid_manager.get_card_target_bounds(card_clicked)
	if not bounds.has_point(clicked_cell):
		return # click missed the grid (e.g. hit a card/UI) -> propagate normally

	tile_clicked.emit(clicked_cell)
	if GameManager.grid_manager.is_valid_target_cell():
		action_manager.use_card_on_grid(clicked_cell, card_clicked)
		stop_targeting()
	get_viewport().set_input_as_handled()
