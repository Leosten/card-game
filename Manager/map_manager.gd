class_name MapManager

extends Node

const MAX_LEVEL = 13
const MAX_NODES_PER_LEVEL = 7
var map : Dictionary = {}
var MAX_NB_OF_PATHS = 3
var MIN_NB_OF_PATHS = 1
var current_node = MapNodeData

func generate_map():
	var encounter_types = StageManager.level_type
	for level in MAX_LEVEL:
		if level == 0:
			continue
		map.set(level, [])
		for node in MAX_NODES_PER_LEVEL:
			var single_node = MapNodeData.new()
			var encounter_t = StageManager.get_stage_encounter_types(level).pick_random()
			var background = GameManager.card_manager.get_large_card_background(encounter_t)
			single_node.background = background
			single_node.encounter_type = encounter_t
			map[level].append(single_node)
			
	generate_paths()
	print("MAP GENERATED")
	#print(map)

func generate_paths():
	for level in map:
		if level == MAX_LEVEL - 1:
			break
		var next_possible_nodes : Array = map[level + 1].duplicate()
		next_possible_nodes.shuffle()
		
		for starting_node in map[level]:
			if next_possible_nodes.is_empty():
				break
			if level > 1:
				if starting_node.is_tracked == false:
					continue
			var path_nb = randi_range(MIN_NB_OF_PATHS, MAX_NB_OF_PATHS)
			if path_nb >= next_possible_nodes.size():
				path_nb = next_possible_nodes.size()
			for i in path_nb:
				var node_to_add = next_possible_nodes.pop_back()
				node_to_add.is_tracked = true
				starting_node.next_nodes.append(node_to_add)
		cleanup_paths()
		
func cleanup_paths():
	for level in map:
		map[level] = map[level].filter(func(node: MapNodeData): return node.next_nodes.is_empty() == false)
		
	print("PATHS GENERATED")

	print(map)
