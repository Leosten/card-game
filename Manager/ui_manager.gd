var loaded_icons : Dictionary

var ICONS_DIR = "res://Art/UI/icons/"
var ICON_SCENE = preload("res://View/UI/icons/icon_template.tscn")
var ORB_SCENE = preload("res://View/Battle/orb.tscn")
var _icons: Dictionary = {}

func _init() -> void:
	print("uimanager init")
	_cache_all_icons()

func _cache_all_icons() -> void:
	var dir = DirAccess.open(ICONS_DIR)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and not file_name.ends_with(".import"):
				var icon_name = file_name.get_basename().to_lower()
				var texture = load(ICONS_DIR + file_name) as Texture2D
				if texture:
					_icons[icon_name] = texture
			file_name = dir.get_next()
		dir.list_dir_end()

func get_icon_by_name(icon_name: String) -> Texture2D:
	print("icon name : ", icon_name)
	var key = icon_name.to_lower()
	
	if _icons.has(key):
		return _icons[key]
	push_warning("IconManager: No icon found named '%s'" % icon_name)
	return null

func get_all_icon_names() -> Array:
	return _icons.keys()

func get_status_icon(status_type : StatusUtils.names) -> Texture2D:
	match status_type:
		StatusUtils.names.STUN:
			return get_icon_by_name('stun')
		StatusUtils.names.VULNERABLE:
			return get_icon_by_name('vulnerable')
		StatusUtils.names.PERFECT_PROTECT:
			return get_icon_by_name('protect')
		StatusUtils.names.FIRE_AFFINITY:
			return get_icon_by_name('up_buff')
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
	if status is Status:
		icon = get_status_icon(status.type)
		icon_scene.set_icon(icon)
	return icon_scene

func get_orb_scene(orb: CardUtils.magic_type):
	var scene = ORB_SCENE.instantiate()
	scene.init(orb)
	return scene
