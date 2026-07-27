extends Node2D

var battle_state : Dictionary
var current_stage: int
var current_level: int
var current_turn: int = 0
var enemy_turn : bool = false
var stage_monsters : Array[MonsterData]
var monsters_displayed : Array[Monster]
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

func _on_card_clicked(card_data: CardData) -> void:
	card_clicked = card_data
	print("Battle received: ", card_data.name)

func _ready() -> void:
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	#todo: globals
	viewport_size = get_viewport_rect().size
	stage_manager = StageManager.new()
	action_manager = ActionManager.new()
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
	
func _process(delta: float) -> void:
	pass

func spawn_player_character():
	var player_character = GameManager.get_character_scene()
	var char_position := Vector2(
			viewport_size.x - 1650,
			viewport_size.y - 650
		)
	player_character.position = char_position
	add_child(player_character)

func get_level_monsters():
	battle_state["level_monsters"] = stage_manager.get_level_monsters(current_level)

func spawn_level_monsters():
	enemy_positions = stage_manager.init_monster_positions(viewport_size)
	print(battle_state["level_monsters"])
	var monster_scenes = stage_manager.get_monster_scenes_for_level(battle_state["level_monsters"], enemy_positions)
	for monster_scene in monster_scenes :
		monster_scene.clicked.connect(on_monster_clicked)
		monster_scene.hovered.connect(on_monster_hovered)	
		add_child(monster_scene)
		print("test")
		monsters_displayed.append(monster_scene)
	print("Monsters spawned")

func load_stage_monsters():
	stage_monsters = stage_manager.get_stage_monsters(current_level)

func on_monster_clicked(monster_data : MonsterData):
	if (card_clicked != null):
		if (card_clicked.allowed_targets.has(CardUtils.targets.ALL_ENEMIES == 1)):
			action_manager.use_card_on_all_enemies()

		battle_state = action_manager.use_card_on_enemy(card_clicked, battle_state, monster_data.battle_position)
		update_battle_state(battle_state)
		update_displayed_monsters()

func on_monster_hovered(monster_data : MonsterData):
	pass

func update_displayed_monsters():
	for monster_scene in monsters_displayed:
		for monster_data in battle_state["level_monsters"]:
			if monster_scene.monster_data.battle_position == monster_data.battle_position:
				monster_scene.update_monster_state(monster_data)

func on_monster_dead(monster : MonsterData):
	print("monster %s dead!" % monster.battle_position)
	monsters_displayed = MonsterUtils.removeMonsterDeadDisplay(monsters_displayed, monster)
	update_battle_state(battle_state)

func on_death_timer():
	print("death timer done")
	
func update_battle_state(battle_st):
	GameManager.update_battle_state(battle_st)
	battle_state = battle_st

func update_player_mana():
	$ManaWindow/ManaLabel.text = str(battle_state["player_stats"].mana)

func launch_enemy_turn():
	for enemy in battle_state["level_monsters"]:
		battle_state = action_manager.enemy_cycle(battle_state, enemy)
	pass

func _on_end_turn_button_pressed() -> void:
	#card_hand_hud.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	enemy_turn = true
	launch_enemy_turn()
	pass # Replace with function body.
