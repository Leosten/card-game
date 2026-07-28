extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

func init(battle_state: BattleState):
	update(battle_state.player_stats)

func _process(_delta):
	if _animated_sprite.animation.contains("idle"):
		_animated_sprite.play("idle")

func update(player_stats : PlayerStats):
	$HealthBar.max_value = player_stats.max_health
	$HealthBar.value = player_stats.health
	
	
