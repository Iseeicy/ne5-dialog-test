extends BasicProjection
class_name PowerSaverWindow

enum State {
	Closed,
	ShowChoices,
	ShowDialog
}

#
#	Exported
#

signal state_changed(new_state: State)
signal choice_selected(index: int)

#
#	Variables
#

var current_state: State
var emotion_label: Label
var name_label: Label
var dialog_label: RichTextLabel
var text_reader: TextReader
var choice_grid: GridContainer

#
#	Godot Functions
#

# Called when the node enters the scene tree for the first time.
func _ready():
	emotion_label = $EmotionContainer/MarginContainer/Label
	name_label = $NameContainer/MarginContainer/Label
	dialog_label = $ChoiceContainer/MarginContainer/DialogLabel
	text_reader = $ChoiceContainer/MarginContainer/DialogLabel/TextReader
	choice_grid = $ChoiceContainer/MarginContainer/ChoiceGrid
	
	close()

func show_choices(speaker_name: String, emotion: String) -> void:
	name_label.text = speaker_name
	emotion_label.text = emotion
	_set_state(State.ShowChoices)

func show_dialog(speaker_name: String, emotion: String, dialog_text: String) -> void:
	name_label.text = speaker_name
	emotion_label.text = emotion
	_set_state(State.ShowDialog)
	text_reader.start_reading(dialog_text)

func close() -> void:
	_set_state(State.Closed)
	

#
#	Private Functions
#

func _set_state(new_state: State) -> void:
	current_state = new_state
	visible = new_state != State.Closed
	choice_grid.visible = new_state == State.ShowChoices
	dialog_label.visible = new_state == State.ShowDialog
	
	text_reader.cancel_reading()
	state_changed.emit(new_state)
