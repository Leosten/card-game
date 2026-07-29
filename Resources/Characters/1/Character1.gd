extends TargetCharacter

@export var player_stats : PlayerStats

func init(battle_state: BattleState):
	player_stats = battle_state.player_stats
	connect_player_signals()
	update()

func connect_player_signals():
	player_stats.stats_changed.connect(on_stats_changed)
	player_stats.current_mana_changed.connect(on_mana_changed)
	player_stats.damage_taken.connect(on_damage_taken)
	player_stats.buffed

func _process(_delta):
	if not animating:
		_animated_sprite.play("idle")

func update():
	$HealthBar.max_value = player_stats.max_health
	$HealthBar.value = player_stats.health

func on_stats_changed():
	update()

func on_mana_changed():
	#not used right now, scene update is in battle
	pass

func on_damage_taken(damage):
	animating = true
	_animated_sprite.stop()
	_animated_sprite.play("damage_taken")
	await _animated_sprite.animation_finished
	animating = false
