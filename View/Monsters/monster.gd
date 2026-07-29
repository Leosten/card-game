class_name Monster

extends TargetCharacter

signal clicked(monster_data: MonsterData)
signal hovered(monster_data: MonsterData)
signal dead(monster_data: MonsterData)

@export var monster_data : MonsterData = null
var battle_position

func _ready() -> void:
	super()
	input_event.connect(_on_input_event)

func _process(_delta):
	if not animating:
		_animated_sprite.play("idle")

func init_data(m_data: MonsterData):
	monster_data = m_data
	stats = monster_data
	$MonsterName.text = monster_data.name
	$MonsterPosition.text = str(monster_data.battle_position)
	connect_signals()

func connect_signals() :
	monster_data.stats_changed.connect(on_stats_changed)
	monster_data.acting.connect(on_action)
	monster_data.damage_taken.connect(on_damage_taken)
	monster_data.death.connect(on_monster_dead)

func set_battle_position(battle_position):
	monster_data.battle_position = battle_position
	$MonsterPosition.text = str(battle_position)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
		clicked.emit(monster_data)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
		clicked.emit(monster_data)

func _on_area_2d_mouse_entered() -> void:
	hovered.emit(monster_data)

func on_monster_dead():
	animating = true
	_animated_sprite.stop()
	_animated_sprite.play("death")
	await _animated_sprite.animation_finished
	dead.emit(monster_data)
	self.queue_free()

func spawn(battle_positions):
	var target_position = battle_positions[battle_position]
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", target_position.position, 0.5)

func play_action_animation(action_type : MonsterUtils.action_types):
	print("action type %s" % action_type)
	match action_type:
		MonsterUtils.action_types.DAMAGE:
			attack_animation()

func on_action(action_type):
	play_action_animation(action_type)
