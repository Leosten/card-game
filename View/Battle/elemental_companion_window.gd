extends Node2D

var companion_data : ElementalCompanionStats

func _ready() -> void:
	connect_signals()

func connect_signals():
	companion_data.channeled.connect(update_orb)
	companion_data.channel_used.connect(update_orb)
	companion_data.channel_reset.connect(update_orb)
	companion_data.channel_removed.connect(update_orb)
	companion_data.channel_high_trigger.connect(update_orb)
	companion_data.use_ceiling_not_reached.connect(on_use_ceiling_not_reached)

# for orb display
func on_channeled():
	print("channeled")
	pass
func on_channel_used():
	print("channel used")
	pass
func on_channel_reset():
	print("channel reset")
	pass
func on_use_ceiling_not_reached():
	print("channel not reached")
	pass

func update_orb():
	print("updating orbs")
	for displayed_orbs in $OrbBox.get_children():
		displayed_orbs.queue_free()
	for orb in companion_data.channel_orbs:
		$OrbBox.add_child(GameManager.ui_manager.get_orb_scene(orb))
