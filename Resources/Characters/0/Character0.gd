extends TargetCharacter

func init(battle_state: BattleState):
	stats = battle_state.player_stats
	connect_player_signals()

func connect_player_signals():
	super()
	stats.current_mana_changed.connect(on_mana_changed)

func _process(_delta):
	if not animating:
		_animated_sprite.play("idle")

func on_mana_changed():
	#not used right now, scene update is in battle
	pass

func on_damage_taken(damage):
	animating = true
	_animated_sprite.stop()
	_animated_sprite.play("damage_taken")
	await _animated_sprite.animation_finished
	animating = false
