extends CPUParticles2D


func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	set_physics_process(false)
	set_process(false)
	set_process_internal(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)


func _on_remove_timer_timeout() -> void:
	queue_free()
