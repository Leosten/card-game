class_name MonsterManager

var stage_monsters : Array[MonsterData]
var monsters_displayed : Array[Monster]
var level_monsters : Array[MonsterData]

func _init() -> void:
	Events.battle_start.connect(_on_battle_start)

func _on_battle_start():
	load_level_monsters()
	load_monster_scenes_for_level()
	
func load_level_monsters():
	var monsters = GameManager.stage_manager.get_monsters_by_encounter_type()
	var monster_index = 0
	for monster_name in monsters:
			for monster_data : MonsterData in stage_monsters:
				if monster_data.name == monster_name:
					var monster_d = monster_data.duplicate(true)
					monster_d.battle_position = monster_index
					level_monsters.append(monster_d)
			monster_index += 1
	print("load level monsters")

func load_stage_monsters(current_stage : int):
	var monster_names = StageManager.get_stage_possible_monsters(current_stage)
	for name in monster_names:
		var monster = load("res://Resources/Monsters/" + name + "/" + name + ".tres")
		if monster == null:
			printerr("Cannot load monster data ressource %s" % name)
			return
		stage_monsters.append(monster.duplicate(true))
		print("stage monsters loaded")

func load_monster_scenes_for_level():
	var monsters_by_col : Dictionary = {}
	
	for monster_data : MonsterData in level_monsters:
		monsters_by_col.get_or_add(monster_data.starting_column, []).append(monster_data)
	for col in monsters_by_col:
		var occupied_numbers = range(GameManager.grid_manager.MAX_ROW)
		for monster_data in monsters_by_col[col]:
			var monster_scene = get_monster_scene_from_name(monster_data.name)
			print("get_monster_scenes_for_level")
			monster_scene.z_index = 200
			monster_scene.init_data(monster_data)
			monster_scene.hovered.connect(_on_monster_hovered)
			monster_scene.dead.connect(_on_monster_dead)
			occupied_numbers.shuffle()
			var row = occupied_numbers.pop_back()
			GameManager.grid_manager.set_monster_grid_position(monster_scene, col, row)
			monsters_displayed.append(monster_scene)

func get_monster_scene_from_name(monster_name):
	var monster : PackedScene = load("res://View/Monsters/" + monster_name+ "/" + monster_name + ".tscn")
	if monster == null:
		printerr("Cannot load monster scene %s" % monster_name)
		return
	return monster.instantiate()

func _on_monster_hovered():
	pass

func _on_monster_dead(monster : MonsterData):
	print("monster %s dead!" % monster.name)
	Events.monster_dead.emit(monster)
	level_monsters.erase(monster)
	GameManager.grid_manager.clear_cell_data(monster.grid_position)
	GameManager.grid_manager.clear_monster_aoe_preview(monster.grid_position, monster.get_action())
	check_monsters_dead()
	monsters_displayed = MonsterUtils.remove_monster_dead_display(monsters_displayed, monster)

func check_monsters_dead():
	if level_monsters.is_empty() == true:
		print("WIN all enemies dead")
		Events.battle_won.emit()

func get_level_monster_scenes():
	return monsters_displayed
