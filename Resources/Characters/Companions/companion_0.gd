extends CompanionCharacter

var companion_stats

func _ready():
	connect_signals()

func connect_signals():
	stats.channeled.connect(on_channeled)
	stats.channel_used.connect(on_channel_used)
	stats.channel_reset.connect(on_channel_reset)
	stats.channel_removed.connect(on_channel_removed)
	stats.channel_high_trigger.connect(on_trigger_high)
	stats.use_ceiling_not_reached.connect(on_use_ceiling_not_reached)

# for character animations
func on_channeled():
	print("channeled")
	pass
func on_channel_used():
	print("channel used")
	pass
func on_channel_reset():
	print("channel reset")
	pass
func on_channel_removed():
	print("channel reset")
	pass
func on_trigger_high():
	print("channel reset")
	pass
func on_use_ceiling_not_reached():
	print("channel not reached")
	pass
