class_name MapManager

extends Node

const MAX_LEVEL = 12
const MAX_NODES_PER_LEVEL = 3

var map : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func generate_map():
	var encounter_types = StageManager.level_type
	
	for level in MAX_LEVEL:
		if level == 0:
			continue
		map.set(level, [])
		for node in MAX_NODES_PER_LEVEL:
			var single_node = {
				"type": StageManager.get_stage_encounter_types(level).pick_random(),
				"selected": false
				}
			map[level].append(single_node)
	print("MAP GENERATED")
	print(map)
