extends Node2D

var companion_data : ElementalCompanionStats

func init(companion_d: ElementalCompanionStats):
	companion_data = companion_d
	update_orb()
	
func update_orb():
	for orb in companion_data.channel_orbs:
		$OrbBox.add_child(GameManager.ui_manager.get_orb_scene(orb))
