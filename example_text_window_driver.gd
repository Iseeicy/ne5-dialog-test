extends Node
class_name ExampleTextWindowDriver

#
#	Exported
#

@export var window: TextWindow

#
#	Variables
#

var _current_sequence: ExampleDialogSequence = null
var _sequence_index: int = -1

#
#	Godot Functions
#

func _ready():
	window.choice_confirmed.connect(_on_text_window_choice_confirmed.bind())

#
#	Functions
#

func show_sequence(sequence: ExampleDialogSequence) -> void:
	_current_sequence = sequence
	_sequence_index = -1
	_next_element()
	
func progress() -> bool:
	if _current_sequence == null:
		return false
		
	_next_element()
	return true
	
func select_choice(choice_index: int) -> void:
	window.confirm_choice(choice_index)
	
func close() -> void:
	_current_sequence = null
	_sequence_index = -1
	window.close()

#
#	Private Functions
#

func _next_element() -> void:
	if _sequence_index > 0:
		var element = _current_sequence.elements[_sequence_index]
		if element is ExampleDialogChoicePrompt:
			return
	
	_sequence_index += 1
	
	# If there is NOT something to display, close the window.
	if _sequence_index < 0 or _sequence_index >= _current_sequence.elements.size():
		close()
		return
		
	# OTHERWISE, we have something to do!
	var element = _current_sequence.elements[_sequence_index]
	
	if element is ExampleDialogText:
		window.show_dialog(element.dialog)
	elif element is ExampleDialogChoicePrompt:
		window.show_choice_prompt(element.prompt)
		
#
#	Signals
#

func _on_text_window_choice_confirmed(index: int, prompt: TextWindowChoicePrompt):
	var element = _current_sequence.elements[_sequence_index] as ExampleDialogChoicePrompt
	show_sequence(element.destinations[index])
