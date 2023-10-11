extends TextWindowState

#
#	Exported
#

@export var choice_container: HBoxContainer

#
#	State Functions
#

func state_enter(_message: Dictionary = {}) -> void:
	_parent_state.state_enter(_message)
	
	choice_container.visible = true
	
func state_unhandled_input(event: InputEvent) -> void:
	_parent_state.state_unhandled_input(event)
	
func state_process(delta: float) -> void:
	_parent_state.state_process(delta)
	
func state_physics_process(delta: float) -> void:
	_parent_state.state_physics_process(delta)
	
func state_exit() -> void:
	_parent_state.state_exit()
	
	choice_container.visible = false

#
#	Signals
#

# Called when the text window wants to display a choice prompt
func _on_text_window_choice_prompt_shown(prompt: TextWindowChoicePrompt):
	# Transition to this state if a choice prompt should be played!
	_state_machine.transition_to(_state_path, { "prompt": prompt })
