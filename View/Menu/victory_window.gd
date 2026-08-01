extends Node

var battle_state : BattleState = GameManager.get_battle_state()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	GameManager.victory_progress()
	Events.next_battle.emit()
	queue_free()
