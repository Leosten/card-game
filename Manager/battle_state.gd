class_name BattleState

var player_stats : PlayerStats
var player_deck : Array[CardData] = []
var level_monsters : Array[MonsterData] = []

signal draw_cards(nb)

func _init():
	pass

func replenish_player_mana():
	CharacterUtils.replenish_mana(player_stats)
	player_stats.current_mana_changed.emit()

func cleanup_fight():
	player_stats.cleanup_fight()
