@abstract class_name Monster
extends AnimatableBody2D

@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var monster_data : MonsterData = null

signal clicked(monster_data: MonsterData)
signal hovered(monster_data: MonsterData)

func _ready() -> void:
	print('mnster rdy')
	input_event.connect(_on_input_event)
	update_health_bar()
	
func init_data(m_data: MonsterData):
	monster_data = m_data
	$MonsterName.text = monster_data.name
	$MonsterPosition.text = str(monster_data.battle_position)

func _process(_delta):
	if _animated_sprite.animation.contains("idle"):
		_animated_sprite.play("idle")

func set_battle_position(battle_position):
	monster_data.battle_position = battle_position
	$MonsterPosition.text = str(battle_position)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("event")
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
		print("event clicked")

		clicked.emit(monster_data)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
		print("event clicked")
		clicked.emit(monster_data)

func _on_area_2d_mouse_entered() -> void:
	hovered.emit(monster_data)

func update_health_bar():
	$HealthBar.max_value = monster_data.max_health
	$HealthBar.value = monster_data.health

func update_monster_state(monster_d):
	monster_data = monster_d
	print("monster %s updated" % str(monster_data.battle_position))
	update_health_bar()
