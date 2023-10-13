extends Node

func _input(event):
	if is_mouse_locked():
		if event.is_action("ui_cancel"):
			set_mouse_locked(false)
	else:
		if event is InputEventMouseButton:
			if event.is_pressed():
				set_mouse_locked(true)
	
	
func is_mouse_locked() -> bool:
	return Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	
func set_mouse_locked(is_locked: bool):
	if is_locked:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
