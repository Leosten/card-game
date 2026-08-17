class_name CardManager
extends Node

const PlayerManager = preload("res://Manager/character_manager.gd")
const Card = preload("res://View/Cards/card.tscn")

var _backgrounds = {
	CardUtils.card_type.ELEMENTAL: preload("res://Art/UI/cards/card_black_lily.png"),
	CardUtils.card_type.MAGIC: preload("res://Art/UI/cards/card_black_sakura.png"),
	CardUtils.card_type.BUFF: preload("res://Art/UI/cards/card_black_bamboo.png"),
	CardUtils.card_type.ATTACK: preload("res://Art/UI/cards/card_black_kitsune.png"),
}

var _large_cards = {
	StageManager.level_type.COMMON: preload("res://Art/UI/cards/large_cards/card_large_common.png"),
	StageManager.level_type.MINIBOSS: preload("res://Art/UI/cards/large_cards/card_large_miniboss.png"),
	StageManager.level_type.BOSS: preload("res://Art/UI/cards/large_cards/card_large_boss.png"),
	StageManager.level_type.TREASURE: preload("res://Art/UI/cards/large_cards/card_large treasure.png"),
	StageManager.level_type.SHOP: preload("res://Art/UI/cards/large_cards/card_large_shop.png"),
	StageManager.level_type.FORGE: preload("res://Art/UI/cards/large_cards/card_large_forge.png"),
}

var _cards_by_deck: Dictionary = {}
var _cards_by_name: Dictionary = {}

const BASE_CARDS_DIR = "res://Resources/Cards/"
const PORTRAITS_FOLDER_DIR = "res://Art/UI/cards/portraits/"

func _init() -> void:
	_load_all_cards_recursive(BASE_CARDS_DIR)
	
func _load_all_cards_recursive(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if not dir:
		print("Failed to open path: ", dir_path)
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		var full_path = dir_path.path_join(file_name)
		
		# 1. If it's a folder (e.g. "warrior"), scan inside it recursively
		if dir.current_is_dir() and not file_name.begins_with("."):
			_load_all_cards_recursive(full_path)
			
		# 2. If it's a card resource file (.tres)
		elif file_name.ends_with(".tres"):
			var card_res = load(full_path) as CardData
			if card_res:
				# Extract folder name as the class ID (e.g., "warrior")
				# If in root directory, default to "neutral"
				var folder_name = dir_path.get_file()
				if folder_name == "cards" or folder_name.is_empty():
					folder_name = "neutral"
				folder_name = folder_name.to_lower()
				
				
				
				var card_id = file_name.get_basename().to_lower()
				var portrait_path = PORTRAITS_FOLDER_DIR + card_id + ".png"
				# add portraits texture2D
				if FileAccess.file_exists(portrait_path):
					card_res.artwork = load(portrait_path)
				else:
					card_res.artwork = load(PORTRAITS_FOLDER_DIR + "logo.png")
					
				# Add to class pool
				if not _cards_by_deck.has(folder_name):
					_cards_by_deck[folder_name] = [] as Array[CardData]
				_cards_by_deck[folder_name].append(card_res)
				
				# Add to global name lookup
				_cards_by_name[card_id] = card_res
				
		file_name = dir.get_next()
	dir.list_dir_end()

func get_card_by_name(card_name: String) -> CardData:
	return _cards_by_name.get(card_name.to_lower(), null)

func get_starting_deck(character_id) -> Array[CardData]:
	var character_deck = PlayerManager._get_character_starting_deck(character_id)
	var deck : Array[CardData] = []
	for card_name in character_deck:
		deck.append(get_card_by_name(card_name).duplicate())
	return deck

func get_card_scene():
	return Card.instantiate()

## Fetch background texture by type string/enum
func get_card_background(card_type: CardUtils.card_type) -> Texture2D:
	if _backgrounds.has(card_type):
		return _backgrounds[card_type]
	
	push_warning("CardDatabase: Background not found for type '%s'. Using neutral fallback." % card_type)
	return _backgrounds[CardUtils.card_type.ATTACK]
	
func get_large_card_background(level_type: StageManager.level_type) -> Texture2D:
	if _large_cards.has(level_type):
		return _large_cards[level_type]
	push_warning("large card background not found")
	return _large_cards[StageManager.level_type.COMMON]
	
func get_random_card_for_deck(character_class: String) -> CardData:
	var key = character_class.to_lower()
	if _cards_by_deck.has(key) and not _cards_by_deck[key].is_empty():
		return _cards_by_deck[key].pick_random()
	return null

func get_card_rewards_by_deck(deck_nb, count: int = 3) -> Array[CardData]:
	var rewards: Array[CardData] = []
	var cards = _cards_by_deck.get(str(deck_nb), [])
	
	cards.filter(func(card): return card.tier == CardUtils.tier.COMMON)
	cards.shuffle()

	for i in range(min(count, cards.size())):
		rewards.append(cards[i].duplicate())
		
	return rewards
