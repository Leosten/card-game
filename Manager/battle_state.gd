class_name BattleState

var player_stats : PlayerStats
var player_deck : Array[CardData] = []
var level_monsters : Array[MonsterData] = []
#var companion_stats : CompanionStats

signal draw_cards(nb)

func _init():
	pass

func replenish_player_mana():
	CharacterUtils.replenish_mana(player_stats)
	player_stats.current_mana_changed.emit()
