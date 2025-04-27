extends Control

func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()

	get_window().focus_exited.connect( _on_window_focus_exited, CONNECT_ONE_SHOT,)

func _on_window_focus_exited() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()

