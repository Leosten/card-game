extends Node2D

var battle_state : Dictionary
var current_stage: int
var current_level: int
var current_turn: int = 0
var stage_monsters : Array[MonsterData]
const StageManager = preload("res://Manager/stage_manager.gd")
const ActionManager = preload("res://Manager/action_manager.gd")
var monsters_displayed : Array[Monster]

var stage_manager : StageManager
var action_manager : ActionManager
var viewport_size
var enemy_positions : Array[Area2D] = []

@onready var card_hand_hud = $CardHandHud

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
	
	spawn_player_character()
	load_stage_monsters()
	get_level_monsters()
	enemy_positions = stage_manager.init_monster_positions(viewport_size)
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
	print("Spawning monsters")
	var index = 0
	for monster_data in battle_state['level_monsters']:
		var monster_scene = stage_manager.get_monster_scene_from_id(monster_data.id)
		monster_scene.init_data(monster_data.duplicate())
		monster_scene.position = enemy_positions[index].position
		monster_scene.clicked.connect(on_monster_clicked)
		monster_scene.hovered.connect(on_monster_hovered)
		monster_scene.z_index = 100
		add_child(monster_scene)
		monsters_displayed.append(monster_scene)
		index += 1
		print("Monster %s spawned" % str(index))

func load_stage_monsters():
	stage_monsters = stage_manager.get_stage_monsters(current_level)

func on_monster_clicked(monster_data : MonsterData):
	if (card_clicked != null):
		if (card_clicked.allowed_targets.has(CardUtils.targets.ALL_ENEMIES == 1)):
			action_manager.use_card_on_all_enemies()

		battle_state = action_manager.use_card_on_enemy(card_clicked, battle_state, monster_data.battle_position)
		update_displayed_monsters()

func on_monster_hovered(monster_data : MonsterData):
	pass

func update_displayed_monsters():
	for monster_scene in monsters_displayed:
		for monster_data in battle_state["level_monsters"]:
			if monster_scene.monster_data.battle_position == monster_data.battle_position:
				monster_scene.update_monster_state(monster_data)
			
