extends TextWindowState

#
#	State Functions
#

func state_enter(_message: Dictionary = {}) -> void:
	text_window.visible = false

#
#	Signals
#

# Called when the text window should close
func _on_text_window_closed():
	# If we should close the text window, transition to this state NOW!
	_state_machine.transition_to(_state_path)
