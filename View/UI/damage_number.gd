extends Label

func setup(amount: int) -> void:
	text = str(amount)
	
	#if is_critical:
		#modulate = Color.YELLOW
		#scale = Vector2(1.5, 1.5)
	#else:
	modulate = Color.WHITE
	scale = Vector2.ONE
		
	_animate()

func _animate() -> void:
	var tween = create_tween().set_parallel(true)
	
	# Float upward
	tween.tween_property(self, "global_position:y", global_position.y - 40, 1.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	# Fade out near the end
	tween.tween_property(self, "modulate:a", 0.0, 0.8)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	# Automatically clean up node after tween finishes!
	tween.chain().tween_callback(queue_free)
