class_name BattleState

var player_stats : PlayerStats
var companion_stats : CompanionStats
var player_deck : Array[CardData] = []
var current_turn : int = 0

signal draw_cards(nb)

func _init():
	pass

func replenish_player_mana():
	CharacterUtils.replenish_mana(player_stats)
	player_stats.current_mana_changed.emit()

func cleanup_fight():
	player_stats.cleanup_fight()
	companion_stats.cleanup_fight()
