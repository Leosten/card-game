extends Node2D

var battle_state : BattleState
var current_stage: int
var current_level: int
var current_turn: int = 0
var enemy_turn : bool = false
var stage_monsters : Array[MonsterData]
var monsters_displayed : Array[Monster]
var player_character : CharacterBody2D
var death_timer: SceneTreeTimer
const StageManager = preload("res://Manager/stage_manager.gd")
const ActionManager = preload("res://Manager/action_manager.gd")
var stage_manager : StageManager
var action_manager : ActionManager

var viewport_size
var enemy_positions : Array[Area2D] = []

@onready var card_hand_hud = $CardHandHud
@onready var mana_window = $ManaWindow

var card_clicked: CardData = null

func _ready() -> void:
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	#todo: globals
	viewport_size = get_viewport_rect().size
	stage_manager = StageManager.new()
	action_manager = ActionManager.new()
	action_manager.card_used.connect(on_card_used)
	action_manager.mana_used.connect(on_mana_used)
	action_manager.update_battle_view.connect(refresh_screen)
	current_turn = 1
	battle_state = GameManager.get_battle_state()
	current_level = GameManager.current_level
	current_stage = GameManager.current_stage
	Events.monster_dead.connect(on_monster_dead)
	
	spawn_player_character()
	update_player_mana()
	load_stage_monsters()
	get_level_monsters()
	spawn_level_monsters()
	card_hand_hud.update_displayed_hand_cost(battle_state)

func _process(delta: float) -> void:
	pass

func spawn_player_character():
	player_character = GameManager.get_character_scene()
	var char_position := Vector2(
			viewport_size.x - 1550,
			viewport_size.y - 650
		)
	player_character.position = char_position
	player_character.init(battle_state)
	add_child(player_character)

func update_player_character():
	player_character.update(battle_state.player_stats)
	
func get_level_monsters():
	battle_state.level_monsters = stage_manager.get_level_monsters(current_level)

func spawn_level_monsters():
	enemy_positions = stage_manager.init_monster_positions(viewport_size)
	var monster_scenes = stage_manager.get_monster_scenes_for_level(battle_state.level_monsters, enemy_positions)
	for monster_scene in monster_scenes :
		monster_scene.clicked.connect(on_monster_clicked)
		monster_scene.hovered.connect(on_monster_hovered)	
		monster_scene.update_health_bar()
		add_child(monster_scene)
		monsters_displayed.append(monster_scene)
	print("Monsters spawned")

func load_stage_monsters():
	stage_monsters = stage_manager.get_stage_monsters(current_level)
	
func _on_card_clicked(card_data: CardData) -> void:
	if card_clicked != null && card_data.hand_position == card_clicked.hand_position:
		battle_state = action_manager.use_card_on_ally(card_clicked, battle_state)
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
		battle_state = action_manager.use_card_on_enemy(card_clicked, battle_state, monster_data.battle_position)
		card_clicked = null
		
func on_card_used(card_data : CardData):
	card_hand_hud.discard_card(card_clicked)

func on_mana_used(cost):
	card_hand_hud.update_displayed_hand_cost(battle_state)
	update_player_mana()

func refresh_screen():
	update_displayed_monsters()

func on_monster_hovered(monster_data : MonsterData):
	pass

func update_displayed_monsters():
	monsters_displayed = MonsterUtils.update_level_monsters(monsters_displayed, battle_state)

func on_monster_dead(monster : MonsterData):
	print("monster %s dead!" % monster.battle_position)
	monsters_displayed = MonsterUtils.remove_monster_dead_display(monsters_displayed, monster)

func update_player_mana():
	print(battle_state.player_stats.current_mana)
	var color
	if (CharacterUtils.get_current_mana(battle_state) > 0):
		color = Color(0.149, 0.959, 0.792, 1.0)
	else:
		color = Color(0.0, 0.0, 0.0, 1.0)
	$ManaWindow/ManaLabel.label_settings.font_color = color
	$ManaWindow/ManaLabel.text = str(battle_state.player_stats.current_mana)

func launch_enemy_turn():
	for enemy in battle_state.level_monsters:
		battle_state = action_manager.enemy_cycle(battle_state, enemy)
	update_player_character()
	pass

func _on_end_turn_button_pressed() -> void:
	#card_hand_hud.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	enemy_turn = true
	launch_enemy_turn()
	card_hand_hud.discard_all()
	battle_state = CharacterUtils.replenish_mana(battle_state)
	card_hand_hud.new_turn()
	update_player_mana()
	enemy_turn = false
