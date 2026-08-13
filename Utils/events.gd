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

signal next_battle
signal game_completed
