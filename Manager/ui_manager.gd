var loaded_icons : Dictionary

var ICONS_DIR = "res://Art/UI/icons/"
var ICON_SCENE = preload("res://View/UI/icons/icon_template.tscn")
#func load_all_icons():
	#for status_name in StatusUtils.status_effects:
		#var status_value: int = StatusUtils.status_effects[status_name]
		#var icon = load("res://View/UI/icons/" + str(status_name).to_lower() + "_icon.tscn")
		#loaded_icons[status_value] = icon
	#print("icons loaded")
	#print(loaded_icons)
#
#func get_icon(icon):
	#return loaded_icons[icon]

# Dictionary structure: { "sword": Texture2D, "health_potion": Texture2D }
var _icons: Dictionary = {}

func _init() -> void:
	print("uimanager init")
	_cache_all_icons()
	print(get_all_icon_names())

func _cache_all_icons() -> void:
	var dir = DirAccess.open(ICONS_DIR)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		print("dir  ", file_name)
		while file_name != "":
			if not dir.current_is_dir() and not file_name.ends_with(".import"):
				var icon_name = file_name.get_basename().to_lower()
				var texture = load(ICONS_DIR + file_name) as Texture2D
				
				if texture:
					_icons[icon_name] = texture
					
			file_name = dir.get_next()
		dir.list_dir_end()

func get_icon_by_name(icon_name: String) -> Texture2D:
	var key = icon_name.to_lower()
	
	if _icons.has(key):
		return _icons[key]
	push_warning("IconManager: No icon found named '%s'" % icon_name)
	return null

func get_all_icon_names() -> Array:
	return _icons.keys()

func get_buff_icon(buff_type: StatusUtils.buffs) -> Texture2D:
	match buff_type:
		StatusUtils.buffs.PERFECT_PROTECT:
			return get_icon_by_name('protect')
	return null

func get_status_icon(status_type : StatusUtils.status_effects) -> Texture2D:
	match status_type:
		StatusUtils.status_effects.STUN:
			return get_icon_by_name('stun')
		StatusUtils.status_effects.VULNERABLE:
			return get_icon_by_name('vulnerable')
	return null

func get_monster_action_icon(action_type : MonsterUtils.action_types):
	match action_type:
		MonsterUtils.action_types.DAMAGE:
			return get_icon_by_name('damage')
		MonsterUtils.action_types.DAMAGE_STATUS:
			return get_icon_by_name('status_damage_green')
		MonsterUtils.action_types.SHIELD:
			return get_icon_by_name('shield')
		MonsterUtils.action_types.BUFF, MonsterUtils.action_types.BUFF_OTHERS:
			return get_icon_by_name('up_buff')
		MonsterUtils.action_types.HEAVY_DAMAGE:
			return get_icon_by_name('heavy_damage')
		MonsterUtils.action_types.HEAL_SELF, MonsterUtils.action_types.HEAL_OTHERS:
			return get_icon_by_name('heal')

func get_icon_scene(status : Status):
	var icon_scene = ICON_SCENE.instantiate()
	var icon : Texture2D = null
	if status is StatusEffect:
		icon = get_status_icon(status.type)
	if status is Buff:
		icon = get_buff_icon(status.type)
	if icon_scene.has_method("update"):
		icon_scene.update(status, icon)
	return icon_scene
