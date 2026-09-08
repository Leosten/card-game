extends Node2D

func _on_shop_button_pressed() -> void:
	Events.request_window_open.emit("forge")

func _on_next_button_pressed() -> void:
	Events.request_window_close.emit("forge")
	Events.request_window_open.emit("map", {"selection" : true})
	self.queue_free()
