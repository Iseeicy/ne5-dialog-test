extends Control
class_name WeeksPassingWindow

enum State {
	Closed,
	ShowText,
	ShowDialog,
	ShowChoice
}

#
#	Exported
#

signal state_changed(new_state: State)
signal choice_selected(index: int, text: String)

#
#	Variables
#

var text_header: RichTextLabel
var text_content: RichTextLabel
var text_content_reader: TextReader
var button_container: HBoxContainer
var left_button: Button
var right_button: Button
var current_state: State

#
#	Godot Functions
#

func _ready():
	text_header = $PanelContainer/MarginContainer/VBoxContainer/TextHeader
	text_content = $PanelContainer/MarginContainer/VBoxContainer/TextContent
	button_container = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
	left_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LeftButton
	right_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/RightButton
	
	text_content_reader = text_content.find_child("TextReader")
	
	close()

#
#	Public Functions
#

func display_text(text: String) -> void:
	_set_state(State.ShowText)
	text_content_reader.start_reading(text)
	
func display_dialog(speaker_name: String, text: String) -> void:
	_set_state(State.ShowDialog)
	text_header.text = speaker_name
	text_content_reader.start_reading(text)
	
func display_choice(choice_text: String, left_option: String, right_option: String) -> void:
	_set_state(State.ShowChoice)
	text_header.text = choice_text
	left_button.text = left_option
	right_button.text = right_option

func close() -> void:
	_set_state(State.Closed)
	
func get_state() -> State:
	return current_state

#
#	Private Functions
#

func _set_state(new_state: State) -> void:
	current_state = new_state
	visible = new_state != State.Closed
	text_header.visible = false
	text_content.visible = false
	button_container.visible = false
	
	match(new_state):
		State.ShowText:
			text_content.visible = true
		State.ShowDialog:
			text_header.visible = true
			text_content.visible = true
		State.ShowChoice:
			text_header.visible = true
			button_container.visible = true
			text_content_reader.cancel_reading()
		State.Closed:
			text_content_reader.cancel_reading()
	
	state_changed.emit(new_state)

#
#	Signals
#

func _on_left_button_pressed():
	choice_selected.emit(0, left_button.text)

func _on_right_button_pressed():
	choice_selected.emit(1, right_button.text)
