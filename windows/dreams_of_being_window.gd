extends Control
class_name DreamsOfBeingWindow

enum State {
	Closed,
	ShowChoices,
	ShowDialog
}

#
#	Exported
#

signal state_changed(new_state: State)
signal choice_selected(index: int, text: String)

@export_group("Required Scenes")
@export var choice_button_scene: PackedScene

@export_group("Required References")
@export var header_container: Control
@export var header_label: RichTextLabel
@export var dialog_contents_container: Control
@export var dialog_text_reader: TextReader
@export var choice_contents_container: Control
@export var choice_spawn_container: Control

#
#	Variables
#

var current_state: State

#
#	Godot Methods
#

# Called when the node enters the scene tree for the first time.
func _ready():
	close()

#
#	Methods
#

func show_choices(choices: Array[String]) -> void:
	_set_state(State.ShowChoices)
	
	# Remove any choices that already exist
	for child in choice_spawn_container.get_children():
		child.queue_free()
		
	# Spawn choice buttons
	var current_index: int = 0
	for choice_text in choices:
		# Create a callback for this button to call when selected
		var button_callback = func():
			var button_text = choice_text
			var button_index = current_index
			print("Hey! %s (%s) was pressed." % [button_text, button_index])
			choice_selected.emit(button_index, button_text)
		
		# Spawn the button
		var new_button: Button = choice_button_scene.instantiate()
		choice_spawn_container.add_child(new_button)
		new_button.text = choice_text
		new_button.pressed.connect(button_callback.bind())
		
		current_index += 1
		

func show_dialog(speaker_name: String, dialog_text: String) -> void:
	_set_state(State.ShowDialog)
	header_label.text = speaker_name
	dialog_text_reader.start_reading(dialog_text)

func close() -> void:
	_set_state(State.Closed)

#
#	Private Methods
#

func _set_state(new_state: State) -> void:
	current_state = new_state
	visible = new_state != State.Closed
	
	header_container.visible = false
	dialog_contents_container.visible = false
	choice_contents_container.visible = false
	
	match(new_state):
		State.ShowChoices:
			choice_contents_container.visible = true
		State.ShowDialog:
			header_container.visible = true
			dialog_contents_container.visible = true
			
	dialog_text_reader.cancel_reading()
	state_changed.emit(new_state)
