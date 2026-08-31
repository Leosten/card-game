extends Node

signal monster_dead(monster_data: MonsterData)
signal player_death()
signal monster_damage_taken(damage_value, position)
signal player_damage_taken(damage_value, position)
signal damage_taken(damage, position)
signal enemy_hit()
signal player_healed()
signal player_buffed()
signal player_shielded()

signal turn_start
signal turn_end


signal next_encounter
signal battle_start
signal battle_won
signal battle_lost
signal game_completed


signal request_window_open
signal request_window_close
