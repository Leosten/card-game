extends CompanionCharacter

func init(stats_data : CompanionStats):
	super(stats_data)
	connect_signals()
	update_orbs()

func connect_signals():
	stats.channeled.connect(on_channeled)
	stats.channel_used.connect(on_channel_used)
	stats.channel_reset.connect(on_channel_reset)
	stats.use_ceiling_not_reached.connect(on_use_ceiling_not_reached)

func update_orbs():
	pass

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
