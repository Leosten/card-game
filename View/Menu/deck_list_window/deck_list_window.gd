extends Control

signal card_upgraded
signal card_copied
signal card_removed

var player_deck : Array[CardData]
var compare_window_scene = preload("res://View/Menu/deck_list_window/card_compare_window.tscn")

@onready var card_grid = %CardGrid
@onready var nb_label = %NbLabel
@onready var select_btn = %SelectButton

var selection = false
var selection_type : CardUtils.card_selection_types
var selected_card : CardData = null
var card_upgrade_item : UpgradeItem = null

func _ready() -> void:
	self.z_index = 999
	player_deck = GameManager.battle_state.player_deck
	display_deck()
	select_btn.visible = selection

func with_data(extra_data : Dictionary):
	if extra_data.has("selection"):
		selection = extra_data.selection
		selection_type = extra_data.selection_type
		if selection_type == CardUtils.card_selection_types.UPGRADE:
			card_upgrade_item = extra_data.upgrade

func display_deck():
	nb_label.text = str(player_deck.size())
	for card_data in player_deck:
		var card : Card = GameManager.card_manager.instantiate_card_scene(card_data)
		card.hovered.connect(_on_card_hovered)
		card.hovered_out.connect(_on_card_hovered_out)
		card.clicked.connect(_on_card_clicked)
		card_grid.add_child(card)
		card.update()

func _on_card_hovered(card : Card):
	CardAnimationManager.zoom_in(card)

func _on_card_clicked(card : Card):
	selected_card = card.card_data
	match selection_type:
		CardUtils.card_selection_types.REMOVE:
			selected_card = card.card_data
			print("selected card to remove : ", card.card_data.name)
			return
		#CardUtils.card_selection_types.COPY:
			#selected_card = card.card_data
			#print("selected card to remove : ", card.card_data.name)
			#return
		CardUtils.card_selection_types.UPGRADE:
			var card_preview = card.card_data.duplicate(true)
			if card_upgrade_item.upgrade.type != CardUtils.card_upgrades_types.COPY:
				print("here ", card_upgrade_item.upgrade.type, "   " ,CardUtils.card_upgrades_types.COPY )
				card_upgrade_item.upgrade.apply_upgrade(card_preview)
			var compare_window = compare_window_scene.instantiate()
			compare_window.card_accepted.connect(_on_card_upgrade_accepted)
			add_child(compare_window)
			compare_window.set_cards(card.card_data, card_preview)
			return
		
	print("card clicked")
	if selection == false:
		return
	if card == selected_card:
		selected_card = null
		CardAnimationManager.zoom_out(card)
	CardAnimationManager.zoom_in(card)
	selected_card = card.card_data

func open_compare_window():
	var compare_window = compare_window_scene.instantiate()
	compare_window.card_accepted.connect()

func _on_card_hovered_out(card : Card):
	if card == selected_card:
		return
	CardAnimationManager.zoom_out(card)

func select_card():
	if selection_type == CardUtils.card_selection_types.REMOVE:
		GameManager.battle_state.player_deck.erase(selected_card)
		Events.card_removed.emit()
		print("card removed")
	close()

func _on_card_upgrade_accepted():
	card_upgrade_item.upgrade.apply_upgrade(selected_card)
	Events.card_upgraded.emit(card_upgrade_item)
	close()

func close():
	self.queue_free()

func _on_leave_button_pressed() -> void:
	close()

func _on_close_button_pressed() -> void:
	close()
