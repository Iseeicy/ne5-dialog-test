extends RichTextLabel
class_name DialogLabel

#
#	Exported
#

signal text_started(dialog_text: String)
signal text_stopped(dialog_text: String)
signal text_completed(dialog_text: String)
signal text_canceled(dialog_text: String)
signal text_fast_forwarded(dialog_text: String)
signal new_character_shown(char: String)
@export var display_speed: float = 0

#
#	Variables
#

# How long to wait after displaying a normal character
const CHAR_DISPLAY_SPEED: float = 0.03

# How long to wait after displaying punctuation
const CHAR_PUNCTUATION_DISPLAY_SPEED: float = 0.4

var running_sequence: bool = false
var paused: bool = false
var max_visible_characters: int = 0
var time_until_next_char: float = 0
var previous_char: String = ''

#
#	Godot Functions
#

func _process(delta):
	if running_sequence and not paused:
		_handle_show_sequence(delta)
#
#	Functions
#

func start_show_dialog(dialog_text: String) -> void:
	if running_sequence:		# If dialog is already showing...
		cancel_show_dialog()	# ... un-show it
	
	running_sequence = true	# Set our internal state correctly
	paused = false			# Make sure we're not paused
	time_until_next_char = 0
	previous_char = ''
	
	visible_characters = 0	# Hide all visible text...
	max_visible_characters = _strip_bbcode(dialog_text).length()
	text = dialog_text		# ...then set the text content (invisible)
	text_started.emit(dialog_text)
	
func fast_forward() -> void:
	running_sequence = false	# Set our internal state correctly
	paused = false				# Reset pause (we can't be paused if not playing)
	visible_characters = -1		# And REVEAL ALL TEXT
	text_fast_forwarded.emit(text)
	text_stopped.emit(text)
	
func cancel_show_dialog() -> void:
	running_sequence = false	# Set our internal state correctly
	paused = false				# Reset pause (we can't be paused if not playing)
	
	var dialog_text = text
	text = ""				# Remove all text
	visible_characters = 0	# And hide any text in the future
	text_canceled.emit(dialog_text)
	text_stopped.emit(dialog_text)
	
func set_show_paused(should_pause: bool) -> void:
	paused = should_pause
	
func is_show_paused() -> bool:
	return paused

#
#	Private Functions
#

func _handle_show_sequence(delta: float) -> void:
	time_until_next_char -= delta	# Count down the timer...
	
	# If we should display the next character NOW...
	if time_until_next_char <= 0:
		_handle_show_next_char()							# Display the char & reset timer
		if visible_characters >= max_visible_characters:	# Handle end of dialog if needed
			_handle_reached_end_of_dialog()
			
func _handle_show_next_char() -> void:
	var stripped_text = _strip_bbcode(text)
	
	if stripped_text.length() <= 0:
		return
	
	# Visibly show the next character
	visible_characters += 1
	
	# Reset the character timer
	var char = stripped_text[visible_characters - 1]
	time_until_next_char = _get_char_display_speed(char, stripped_text, visible_characters - 1)
	previous_char = char
	new_character_shown.emit(char)

func _handle_reached_end_of_dialog() -> void:
	running_sequence = false
	paused = false
	text_completed.emit(text)
	text_stopped.emit(text)
	
func _get_char_display_speed(char: String, dialog_text: String, index: int) -> float:
	# If there's multiple characters in a row, then treat this as a normal char
	if index + 1 < dialog_text.length():
		if char == dialog_text[index + 1]:
			return CHAR_DISPLAY_SPEED
	
	match char:
		' ':
			return 0
		'.', '!', ',', '?', '-', ':', ';', '\n':
			return CHAR_PUNCTUATION_DISPLAY_SPEED
		_:
			return CHAR_DISPLAY_SPEED

func _strip_bbcode(source: String) -> String:
	# Thanks to https://github.com/godotengine/godot-proposals/issues/5056#issuecomment-1203033323!
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)
