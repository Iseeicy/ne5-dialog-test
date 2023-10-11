extends TextWindowState

#
#	Exported
#

@export_group("Required References")
@export var header_label: RichTextLabel
@export var text_content: RichTextLabel
@export var text_reader: TextReader

#
#	State Functions
#

func state_enter(_message: Dictionary = {}) -> void:
	_parent_state.state_enter(_message)
	
	header_label.visible = true
	text_content.visible = true
	
func state_unhandled_input(event: InputEvent) -> void:
	_parent_state.state_unhandled_input(event)
	
func state_process(delta: float) -> void:
	_parent_state.state_process(delta)
	
func state_physics_process(delta: float) -> void:
	_parent_state.state_physics_process(delta)
	
func state_exit() -> void:
	_parent_state.state_exit()
	
	header_label.visible = false
	text_content.visible = false
	
