class_name UiManager

var loaded_icons : Dictionary

func load_all_icons():
	for status_name in StatusUtils.status_effects:
		var status_value: int = StatusUtils.status_effects[status_name]
		var icon = load("res://View/UI/icons/" + str(status_name).to_lower() + "_icon.tscn")
		loaded_icons[status_value] = icon
	print("icons loaded")
	print(loaded_icons)
	
func get_icon(icon):
	return loaded_icons[icon]
