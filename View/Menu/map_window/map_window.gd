extends Control

var map : Array
var map_node_scene = preload("res://View/Menu/map_window/map_node.tscn")
var map_nodes : Array = []
@onready var map_container : Control = %MapContainer
@onready var next_btn : Control = %NextButton
@onready var close_btn : Control = %CloseButton
const map_container_margin = 150

@export var line_color: Color = Color.RED
@export var line_width: float = 2.0
@export var cell_width: float = 150
@export var cell_height: float = 150
@export var grid_columns: int = 4
@export var grid_rows: int = 13
@export var cell_size := Vector2(200, 200)
@export var random_jitter := Vector2(20, 15) # Gives organic offset

var half_size := Vector2(75, 75)

var selection = false
var selected_node = null

func _ready() -> void:
	map = GameManager.map_manager.map
	render_map(map)
	update_container_size(grid_columns, grid_rows)
	next_btn.disabled = !selection
	close_btn.visible = !selection
func with_data(extra_data : Dictionary):
	if extra_data.has("selection"):
		selection = extra_data.selection

func _on_map_node_hovered():
	pass
func _on_map_node_hovered_out():
	pass
func _on_map_node_clicked(node: MapNode):
	if selection == false:
		return
	if selected_node == null:
		selected_node = node
		selected_node.select_toggle()
	elif selected_node == node:
		selected_node.select_toggle()
		selected_node = null
	elif selected_node != null:
		selected_node.select_toggle()
		selected_node = node
		selected_node.select_toggle()
	

func render_map(grid: Array) -> void:
	# Dictionary to store MapNodeData -> UI Button instance
	var node_to_button: Dictionary = {}
	
	# 1. Instantiate UI Buttons for non-null grid entries
	for y in range(grid_rows):
		for x in range(grid_columns):
			var data: MapNodeData = grid[y][x]
			if data == null:
				continue
				
			var btn = map_node_scene.instantiate()
			btn.clicked.connect(_on_map_node_clicked)
			btn.init(data)
			# Calculate centered position + random organic jitter
			var base_pos := Vector2(map_container_margin + (x * cell_size.x), map_container_margin + (y * cell_size.y))
			var jitter := Vector2(randf_range(-random_jitter.x, random_jitter.x), randf_range(-random_jitter.y, random_jitter.y))
			btn.position = base_pos + jitter
			
			map_container.add_child(btn)
			btn.set_background()
			node_to_button[data] = btn

	# 2. Draw connections using Line2D between connected nodes
	for y in range(grid_rows):
		for x in range(grid_columns):
			var data: MapNodeData = grid[y][x]
			if data == null:
				continue
				
			var start_btn: Control = node_to_button[data]
			var start_center: Vector2 = start_btn.position
			
			for next_data in data.next_nodes:
				var end_btn: Control = node_to_button[next_data]
				var end_center: Vector2 = end_btn.position
				
				# Create Line2D node
				var line := Line2D.new()
				line.width = 3.0
				line.default_color = Color(1.0, 1.0, 1.0, 1.0)
				line.points = [start_center, end_center] # Explicitly set points array
				
				# Send lines behind buttons visually
				map_container.add_child(line)
				map_container.move_child(line, 0)

func update_container_size(grid_width: int, grid_height: int) -> void:
	# Calculate total pixel height/width needed for all 12 floors
	# Adding extra padding (e.g., 200px) so top/bottom nodes aren't cut off
	var total_width: float = map_container_margin + grid_width * cell_size.x + 200.0
	var total_height: float = grid_height * cell_size.y + 200.0
	
	# Force the custom Control container to expand
	map_container.custom_minimum_size = Vector2(total_width, total_height)


func _on_next_button_pressed() -> void:
	if selection == false:
		return
	if selected_node == null:
		return
	selected_node.node_data.is_walked = true
	GameManager.stage_manager.encounter_progress()
	GameManager.map_manager.current_node = selected_node.node_data
	Events.next_encounter.emit()
	Events.request_window_close.emit("map")

func _on_close_button_pressed() -> void:
	Events.request_window_close.emit("map")
