extends Node2D

var player_stats: PlayerStats
var battle_state : Dictionary
var current_stage: int
var current_level: int
var current_turn: int = 0
var stage_monsters : Array[MonsterData]
const StageManager = preload("res://Resources/stage_manager.gd")
const ActionManager = preload("res://action_manager.gd")
var level_monsters : Array[MonsterData]

var stage_manager : StageManager
var action_manager : ActionManager
var viewport_size 

# positioning variables
var max_nb_of_enemies = 6
var max_nb_of_enemies_per_row = 3

var battle_line_margin = 700
var enemy_first_row = 700
var enemy_first_column = 200
var enemy_column_margin = 300
var row_margin = 250
var enemy_positions : Array[Area2D] = []
@onready var card_hand_hud = $CardHandHud

var card_clicked: CardData = null

func _on_card_clicked(card_data: CardData) -> void:
	card_clicked = card_data
	print("Battle received: ", card_data.name)
	
func _ready() -> void:
	card_hand_hud.card_clicked.connect(_on_card_clicked)
	viewport_size = get_viewport_rect().size
	stage_manager = StageManager.new()
	action_manager = ActionManager.new()
	current_turn = 1
	battle_state = GameManager.get_battle_state()
	current_level = GameManager.current_level
	current_stage = GameManager.current_stage
	print('current_stage is %s' % str(current_stage))
	print('current_level is %s' % str(current_level))
	
	#load player char
	spawn_player_character()

	#load all stage monsters
	load_stage_monsters()
	
	#load level monsters
	get_level_monsters()
	
	# init rows and columns for enemy positions
	init_monster_positions()
	
	#spawn the current level monster scenes
	spawn_level_monsters()
	
	battle_state = GameManager.update_battle_state(
		battle_state['player_stats'],
		battle_state['player_deck'],
		level_monsters)
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	var possible_monsters = stage_manager.get_level_monsters(current_level)
	possible_monsters.shuffle()
	var monster_index = 0
	for monster_id in possible_monsters[0]:
		for monster_data : MonsterData in stage_monsters:
			if monster_data.id == monster_id:
				level_monsters.append(monster_data)
	print("loaded level monsters.")

func spawn_level_monsters():
	print("Spawning monsters")
	var index = 0
	for monster_data in level_monsters:
		var monster_scene = stage_manager.get_monster_scene_from_id(monster_data.id)
		monster_scene.init_data(monster_data.duplicate())
		monster_scene.position = enemy_positions[index].position
		monster_scene.set_battle_position(index)
		monster_scene.clicked.connect(on_monster_clicked)
		monster_scene.z_index = 100
		add_child(monster_scene)

		index += 1
		print("Monster %s spawned" % str(index))

func init_monster_positions() -> void:
	var column_pos = 0
	var row_nb = 0
	var enemy_row_position = enemy_first_row
	var enemy_column_position = enemy_first_column
	
	for monster_pos_index in max_nb_of_enemies:
		var monster_area = Area2D.new()
		
		if (column_pos == max_nb_of_enemies_per_row) :
			column_pos = 0
			row_nb += 1
			enemy_column_position += enemy_column_margin / 2

		var monster_position := Vector2(
			viewport_size.x - (enemy_column_position + (column_pos * enemy_column_margin)),
			viewport_size.y - (enemy_row_position - (row_margin * row_nb))
		)
		column_pos += 1
		monster_area.position = monster_position
		enemy_positions.append(monster_area)
		print("Monster positions initiated")

func load_stage_monsters():
	stage_monsters = stage_manager.get_stage_monsters(current_level)

func on_monster_clicked(monster_data : MonsterData):
	print("monster clicked")
	print("card clicked is %s" % card_clicked.name)
	if (card_clicked != null):
		if (card_clicked.allowed_targets.has(CardData.targets.ALL_ENEMIES == 1)):
			action_manager.use_card_on_all_enemies()

		battle_state = action_manager.use_card_on_enemy(card_clicked, battle_state, monster_data.battle_position)
		print(battle_state.get("level_monsters")[0].health)
