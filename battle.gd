extends Node2D

var battle_state : BattleState
var current_stage: int
var current_level: int
var current_turn: int = 0
var enemy_turn : bool = false
var stage_monsters : Array[MonsterData]
var monsters_displayed : Array[Monster]
var player_character : AnimatableBody2D
var companion_character : AnimatableBody2D
var death_timer: SceneTreeTimer

var stage_manager : StageManager
var action_manager : ActionManager
var battle_animation_manager : BattleAnimationManager

var viewport_size
var enemy_positions : Array[Area2D] = []

@onready var card_hand_hud = $Hud/BottomHudRoot/CardHandHud
@onready var mana_window = $ManaWindow
@onready var level_display = $Hud/TopHudRoot/BattleStats/HBoxContainer/PanelContainer/MarginContainer/CurrentLevelLabel
@onready var center_window = $Hud/CenterWindowRoot
var card_clicked: CardData = null

func _ready() -> void:
	Events.next_battle.connect(start_battle)
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	#todo: globals
	viewport_size = get_viewport_rect().size
	stage_manager = StageManager.new()
	battle_animation_manager = BattleAnimationManager.new()
	add_child(battle_animation_manager)
	action_manager = ActionManager.new()
	action_manager.card_used.connect(on_card_used)
	
	battle_state = GameManager.get_battle_state()
	battle_state.player_stats.current_mana_changed.connect(on_mana_changed)

	current_level = GameManager.current_level
	current_stage = GameManager.current_stage
	spawn_player_character()
	spawn_companion_character()
	current_level = GameManager.current_level
	current_stage = GameManager.current_stage
	new_stage()
	start_battle()

func start_battle():
	current_level = GameManager.current_level
	current_stage = GameManager.current_stage
	print("new battle current stage " , current_stage, " - ", current_level)
	current_turn = 1
	battle_state.replenish_player_mana()
	level_display.text = "Level " + str(current_stage) + " - " + str(current_level)
	update_player_mana()
	get_level_monsters()
	spawn_level_monsters()
	card_hand_hud.start_battle()
	card_hand_hud.new_turn()

func new_stage():
	load_stage_monsters()

func _process(delta: float) -> void:
	pass

func spawn_player_character():
	player_character = GameManager.get_character_scene()
	var char_position := Vector2(
			viewport_size.x - 1550,
			viewport_size.y - 800
		)
	player_character.position = char_position
	player_character.init(battle_state)
	add_child(player_character)

func spawn_companion_character():
	companion_character = GameManager.get_companion_scene()
	var char_position := Vector2(
			viewport_size.x - 1300,
			viewport_size.y - 400
		)
	companion_character.position = char_position
	add_child(companion_character)
	
func get_level_monsters():
	battle_state.level_monsters = stage_manager.get_level_monsters(current_level)

func spawn_level_monsters():
	enemy_positions = stage_manager.init_monster_positions(viewport_size)
	var monster_scenes = stage_manager.get_monster_scenes_for_level(battle_state.level_monsters, enemy_positions)
	for monster_scene : Monster in monster_scenes :
		monster_scene.clicked.connect(on_monster_clicked)
		monster_scene.hovered.connect(on_monster_hovered)
		monster_scene.dead.connect(on_monster_dead)
		add_child(monster_scene)
		monsters_displayed.append(monster_scene)
		monster_scene.spawn(enemy_positions)
		await get_tree().create_timer(0.3).timeout
	print("Monsters spawned")

func load_stage_monsters():
	stage_monsters = stage_manager.get_stage_monsters(current_level)
	
func _on_card_clicked(card_data: CardData) -> void:
	if card_clicked != null and card_data.hand_position == card_clicked.hand_position:
		action_manager.use_card_on_ally(card_clicked, battle_state)
		print(" click on self card")
		card_clicked = null
	if enemy_turn == true:
		return
	if card_data.cost > CharacterUtils.get_current_mana(battle_state):
		print("not enough mana")
		return
	card_clicked = card_data

func on_monster_clicked(monster_data : MonsterData):
	if (card_clicked != null):
		print("card used on enemy")
		action_manager.use_card_on_enemy(card_clicked, battle_state, monster_data)
		card_clicked = null

func on_card_used(card_data : CardData):
	card_hand_hud.discard_card(card_clicked)

func on_mana_changed():
	print("mana changed")
	update_player_mana()
	card_hand_hud.update_displayed_hand_cost(battle_state)

func on_monster_hovered(monster_data : MonsterData):
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

func update_player_mana():
	var color
	if (battle_state.player_stats.current_mana > 0):
		color = Color(0.149, 0.959, 0.792, 1.0)
	else:
		color = Color(0.0, 0.0, 0.0, 1.0)
	$ManaWindow/ManaLabel.label_settings.font_color = color
	$ManaWindow/ManaLabel.text = str(battle_state.player_stats.current_mana)

func launch_enemy_turn():
	for enemy in battle_state.level_monsters:
		action_manager.enemy_cycle(battle_state, enemy)
		await get_tree().create_timer(0.5).timeout

func _on_end_turn_button_pressed() -> void:
	card_hand_hud.end_turn()
	await battle_animation_manager.short_pause()
	enemy_turn = true
	await launch_enemy_turn()
	battle_state.replenish_player_mana()
	update_player_mana()
	action_manager.cycle_statuses(battle_state.player_stats)
	card_hand_hud.new_turn()
	enemy_turn = false

func victory():
	var victory_screen = load("res://View/Menu/victory_window.tscn")
	center_window.add_child(victory_screen.instantiate())
	print("victory screen display")
