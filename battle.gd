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
var current_encounter : StageManager.level_type = StageManager.level_type.COMMON
var stage_manager : StageManager
var action_manager : ActionManager
var battle_animation_manager : BattleAnimationManager

var victory_screen
var next_level_screen

var viewport_size
var enemy_positions : Array[Area2D] = []

@onready var card_hand_hud = $Hud/BottomHudRoot/CardHandHud
@onready var mana_window = $%ManaWindow
@onready var level_display = $Hud/TopHudRoot/BattleStats/HBoxContainer/PanelContainer/MarginContainer/CurrentLevelLabel
@onready var center_window = $Hud/CenterWindowRoot
var card_clicked: CardData = null

func _ready() -> void:
	Events.next_encounter.connect(new_encounter)
	Events.turn_start.connect(on_turn_start)
	Events.turn_end.connect(on_turn_end)
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	#todo: globals
	viewport_size = get_viewport_rect().size
	stage_manager = GameManager.stage_manager
	battle_animation_manager = BattleAnimationManager.new()
	add_child(battle_animation_manager)
	action_manager = ActionManager.new()
	battle_state = GameManager.battle_state

	spawn_player_character()
	spawn_companion_character()
	new_stage()
	start_battle()

func new_encounter():
	current_encounter = GameManager.stage_manager.current_encounter_type
	match current_encounter:
		StageManager.level_type.COMMON:
			start_battle()
		StageManager.level_type.MINIBOSS:
			start_battle()
		StageManager.level_type.BOSS:
			start_boss_battle()
		StageManager.level_type.TREASURE:
			pass
		StageManager.level_type.SPECIAL:
			pass
		StageManager.level_type.SHOP:
			pass
		StageManager.level_type.FORGE:
			pass
		_:
			pass

func start_battle():
	Events.battle_start.emit()
	current_turn = 1
	battle_state.replenish_player_mana()
	battle_state.level_monsters = stage_manager.get_level_monsters()
	spawn_level_monsters()
	Events.turn_start.emit()
	
func start_boss_battle():
	pass

func new_stage():
	stage_monsters = stage_manager.get_stage_monsters()

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
	companion_character.init(battle_state.player_stats.companion_stats)
	
	add_child(companion_character)

func spawn_level_monsters():
	enemy_positions = stage_manager.init_monster_positions(viewport_size)
	var monster_scenes = stage_manager.get_monster_scenes_for_level(battle_state.level_monsters, enemy_positions)
	for monster_scene : Monster in monster_scenes :
		monster_scene.clicked.connect(on_monster_clicked)
		monster_scene.dead.connect(on_monster_dead)
		add_child(monster_scene)
		monsters_displayed.append(monster_scene)
		monster_scene.spawn(enemy_positions)
		await get_tree().create_timer(0.3).timeout
	print("Monsters spawned")

func _on_card_clicked(card_data: CardData) -> void:
	if enemy_turn == true:
		return
	if card_clicked != null and card_data == card_clicked:
		action_manager.use_card_on_ally(card_clicked, battle_state)
		print("click on self card")
		card_clicked = null

	if card_data.cost > CharacterUtils.get_current_mana(battle_state):
		print("not enough mana")
		return
	card_clicked = card_data

func on_monster_clicked(monster_data : MonsterData):
	if (card_clicked != null):
		action_manager.use_card_on_enemy(card_clicked, battle_state, monster_data)
		card_clicked = null

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
		action_manager.enemy_cycle(battle_state, enemy)
		await get_tree().create_timer(0.5).timeout
	Events.turn_start.emit()

func _on_end_turn_button_pressed() -> void:
	Events.turn_end.emit()

func on_turn_end():
	await battle_animation_manager.short_pause()
	await launch_enemy_turn()

func on_turn_start():
	battle_state.replenish_player_mana()
	enemy_turn = false

func victory():
	Events.battle_won.emit()
	await _cleanup_fight()
	Events.request_window_open.emit("reward")

func _cleanup_fight():
	battle_state.cleanup_fight()
	await card_hand_hud.cleanup_fight()
	# status effects
	# exhausted cards
	# clear hands/draw
	# block mouse control filter
	pass
