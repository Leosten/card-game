extends Control

var map : Dictionary
var map_node_scene = preload("res://View/Menu/map_window/map_node.tscn")
var map_nodes : Array = []

const map_container_margin = 100
@export var line_color: Color = Color.RED
@export var line_width: float = 2.0
@export var cell_width: float = 150
@export var cell_height: float = 150
@export var grid_columns: int = 4
@export var grid_rows: int = 12

func _ready() -> void:
	map = GameManager.map_manager.map
	render_map_nodes()
	render_paths()

func render_map_nodes():
	var container_width: float = %MapContainer.size.x 
	var total_grid_width: float = (grid_columns - 1) * cell_width
	var start_x: float = (container_width - total_grid_width) / 2.0

	for level in map:
		var node_pos = 0
		for node : MapNodeData in map[level]:
			var map_node : MapNode = map_node_scene.instantiate()
			map_node.position = Vector2i(
				start_x + cell_width + (cell_width * level),
				map_container_margin + (cell_height * node_pos))
			map_node.hovered.connect(_on_map_node_hovered)
			map_node.hovered_out.connect(_on_map_node_hovered_out)
			map_node.clicked.connect(_on_map_node_clicked)
			%MapContainer.add_child(map_node)

			node.node_position = map_node.position
			map_node.init(node)
			map_nodes.append(map_node)
			node_pos += 1

func render_paths():
	var nb_of_lines = 0
	var nb_of_nodes = 0
	for node : MapNode in map_nodes:
		#print("node positions: ", node.position.x, " " , node.position.y)
		if node.node_data.next_nodes.is_empty():
			continue
		for next_node : MapNodeData in node.node_data.next_nodes:
			print("next node positions: ", next_node.node_position.x, " " , next_node.node_position.y)
			
			var line := Line2D.new()
			line.width = 3.0
			line.default_color = Color.WHITE
			
			var start_pos: Vector2 = node.node_data.node_position
			
			var end_pos: Vector2 = next_node.node_position
			line.points = [start_pos,end_pos]
			%MapContainer.add_child(line)
			nb_of_lines += 1
			#print("NB of lines : ", nb_of_lines)
		nb_of_nodes += 1
		#print("NB of nodes: ", nb_of_nodes)
func _on_map_node_hovered():
	pass
func _on_map_node_hovered_out():
	pass
func _on_map_node_clicked():
	pass
