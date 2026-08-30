class_name MapNodeData
extends Node

var encounter_type : StageManager.level_type
var background : Texture2D
var next_nodes : Array[MapNodeData] = []
var node_position : Vector2
var is_active := false
var is_walked := false
var grid_pos: Vector2i
var level: int
